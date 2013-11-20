#!/usr/bin/env ruby

# Install dotfiles symlinks in places
#
# USAGE:
# Just run it.
#
# Run with `-f` or `--force` to force writing of links.
# Normally, pre-existing files/links are a warning. With this flag,
# Those files will be forcibly deleted & overwritten. So use it carefully!
#
# Run with `-n` or `--dry-run` to see an ouptut of what the script will do.

require 'yaml'
require 'fileutils'

module DotFilesInstaller
  module Env
    def force?
      ARGV.include?('-f') || ARGV.include?('--force')
    end

    def dry_run?
      ARGV.include?('-n') || ARGV.include?('--dry-run')
    end
  end


  # encapsulates a single entry from the manifest, and determines configuration
  # logic that is be determined by that entry
  class ManifestEntry
    # source_glob is the source pattern. options could come in as a string
    # (target file/dir), or a hash
    def initialize(source_glob, options)
      @source_glob = source_glob
      @options = validated_options(options)
    end

    # create links (if needed), deal with existing ones (if needed)
    def process
      if 0 == file_entries.count
        $stderr.puts <<-ERR.split.map(&:strip).join(' ')
        WARNING: '#{source}' in your manifest did not match any files.
        ERR
      else
        file_entries.each(&:create_link_if_needed_and_possible)
      end
    end

    # validate the options, and put them in a consistent form
    def validated_options(options)
      if !options.is_a?(String) && options.is_a?(Hash) &&
        !options.has_key?('target')
        raise ArgumentError.new("Didn't specify a target!")
      end
      options = {'target' => options} if options.is_a?(String)
      options
    end

    # an array of absolute file names, resolved from @source_glob
    def source_file_paths
      @source_file_paths ||= Dir.glob(File.expand_path(@source_glob))
    end

    def file_entries
      @file_etries ||= source_file_paths.map do |source_path|
        FileEntry.new(self, source_path,
          target_path_for_source_path(source_path))
      end
    end

    def target_path_for_source_path(source)
      target = File.expand_path(@options['target'])
      if target_is_dir?
        target = File.join(target, File.basename(source))
      end
      if dotify_target?
        target = File.join(File.dirname(target), '.' + File.basename(target))
      end
      target
    end

    # Whether the target of this entry is dir or file.
    # Determined by how many matching sources there are: if there's only 1
    # matching source, we determine it based on the target name (does it look
    # like a filename?). If there are multiple sources, we assume the target
    # must be a directory.
    def target_is_dir?
      if source_file_paths.count > 1
        true
      else
        !(File.extname(@options['target']).length > 0)
      end
    end

    # true if options['dotify'] is set.
    # Used to determine if a file called "source" maps to "~/source" or
    # "~/.source"
    def dotify_target?
      @options['dotify']
    end
  end # class ManifestEntry


  # encapsulates the configuration & logic for a particular file, derived
  # from a ManifestEntry.
  class FileEntry
    include Env

    # a ManifestEntry, an absolute path to a source file, & an absolute path
    # to the target file
    def initialize(manifest_entry, source, target)
      @manifest_entry = manifest_entry
      @source_path = source
      @target_path = target
    end

    def create_link_if_needed_and_possible(last_chance=false)
      if source_already_linked?
        $stdout.puts "'#{@source_path}' is already linked to '#{@target_path}'"
      elsif target_exists_or_is_broken_link?
        if last_chance
          $stderr.puts <<-ERR.split.map(&:strip).join(' ')
          We already tried to fix this existing file at #{@target_path},
          but we appear to have failed. You should look into that.
          ERR
        else
          delete_or_unlink_existing_target
        end
      else
        create_link
      end
    end

    # actually create the symlink, and ensure the target directory exists
    def create_link
      if !Dir.exists?(File.dirname(@target_path))
        $stdout.puts "'#{File.dirname(@target_path)}' doesn't exist. Creating it."
        FileUtils.mkdir_p(File.dirname(@target_path)) unless dry_run?
      end
      $stdout.puts "Linking '#{@source_path}' -> '#{@target_path}'"
      File.symlink(@source_path, @target_path) unless dry_run?
    end

    # true if our target is already linked to our source file,
    # and nothing needs to be done
    def source_already_linked?
      File.exist?(@target_path) && File.realpath(@target_path) == @source_path
    end

    def existing_link_target_path
      File.realpath(@target_path)
    rescue Errno::ENOENT
      "[BROKEN LINK]"
    end

    # true if the target path is already a real file, a link pointing somewhere else,
    # or a broken link
    def target_exists_or_is_broken_link?
      target_exists_as_real_file? || target_exists_as_link? ||
        target_exists_as_broken_link?
    end

    def target_exists_as_real_file?
      File.exist?(@target_path) && !File.lstat(@target_path).symlink?
    end

    def target_exists_as_link?
      File.lstat(@target_path).symlink? &&
        File.realpath(@target_path) != @source_path
    rescue Errno::ENOENT
      false # probably a broken link, which we don't count as "existing link"
    end

    # true if target is a symlink, but it's broken (points to a missing file)
    def target_exists_as_broken_link?
      # lstat will succeed for broken link, but fail with ENOENT
      # for a truly non-existent file
      begin
        lstat = File.lstat(@target_path)
        if lstat.symlink?
          begin
            # realpath will bail with ENOENT for broken link
            return !(nil != File.realpath(@target_path))
          rescue Errno::ENOENT
            return true # this is a broken link
          end
        end
      rescue Errno::ENOENT
          return false # this is a truly not-there file
      end
    end

    def delete_or_unlink_existing_target
      if !force?
        $stderr.puts <<-ERR.split.map(&:strip).join(' ')
        WARNING: #{target} exists, but is not a symlink to our dotfile
        equivalent.
        ERR
        return
      end

      if target_exists_as_real_file? # real file, delete it
        $stdout.puts <<-MSG.split.map(&:strip).join(' ')
        "#{@target_path} is a real file. Deleting it so we can link."
        MSG
        begin
          File.delete(@target_path) unless dry_run?
        rescue => ex
          $stderr.puts "Delete failed: #{ex}"
        end
      elsif target_exists_as_broken_link? || target_exists_as_link?
        # symlink, but for the wrong/missing file
        $stdout.puts <<-MSG.split.map(&:strip).join(' ')
        #{@target_path} is a symlink to '#{existing_link_target_path}'.
        Unlinking it so we can link.
        MSG
        begin
          File.unlink(@target_path) unless dry_run?
        rescue => ex
          $stderr.puts "Unlink failed: #{ex}"
        end
      end

      # If dry_run, pretend we definitely succeeded in delete/unlink, and
      # just pretend to now actually create the link so user sees
      # "Linking A -> B".
      # If not dry_run, call create_link_if_needed_and_possible again
      # with flag so that if somethings still wrong, user gets notified
      # and we don't go into an infinite loop of trying to delete a file
      if dry_run?
        create_link
      else
        create_link_if_needed_and_possible(true)
      end
    end
  end # class FileEntry


  module StaticMethods
    include Env

    def manifest
      return @manifest if @manifest
      yml = YAML.load(File.open('manifest.yml', 'r').read)
      @manifest = yml.map do |source_glob, options|
        ManifestEntry.new(source_glob, options)
      end
    end

    def run
      $stdout.puts "Running in dry run mode.\n" if dry_run?

      manifest.each(&:process)
    end
  end

  self.extend StaticMethods
end

# make sure that evereything is run in context of directory of install.rb
Dir.chdir File.dirname(__FILE__) do
  DotFilesInstaller.run
end
