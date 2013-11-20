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
  module StaticMethods
    def force?
      ARGV.include?('-f') || ARGV.include?('--force')
    end

    def dry_run?
      ARGV.include?('-n') || ARGV.include?('--dry-run')
    end

    def manifest
      @manifest ||= YAML.load(File.open('manifest.yml', 'r').read)
    end

    # validate the options, and put them in a consistent form
    def validated_options(options)
      if !options.is_a?(String) && options.is_a?(Hash) &&
        !options.has_key?('target')
        raise Exception.new("Didn't specify a target!")
      end
      options = {'target' => options} if options.is_a?(String)

      options
    end

    # source is absolute path at this point
    # Return the absolute path that this source should
    # be linked to
    def target_path(source, options)
      target = File.expand_path(options['target'])
      if options['target_is_dir']
        target = File.join(target, File.basename(source))
      end
      if options['dotify']
        target = File.join(File.dirname(target), '.' + File.basename(target))
      end
      target
    end

    # if the target exists, delete it & try again (if --force), or warn the
    # user
    def delete_old_file(source, target)
      if force?
        puts "FORCE IS ON"
        if !File.lstat(target).symlink?
          # real file, delete it
          $stdout.puts "#{target} is a real file. Deleting it so we can link."
          begin
            File.delete(target) unless dry_run?
          rescue ex
            $stderr.puts "Delete failed: #{ex}"
          end
        elsif file_is_broken_link?(target) || File.realpath(target) != source
          # symlink, but for the wrong/missing file
          $stdout.puts <<-MSG.split.map(&:strip).join(' ')
          #{target} is a symlink to '#{existing_link_target(target)}'.
          Unlinking it so we can link.
          MSG
          begin
            File.unlink(target) unless dry_run?
          rescue ex
            $stderr.puts "Unlink failed: #{ex}"
          end
        end
        create_link(source, target, true) unless dry_run?
      else
        $stderr.puts <<-ERR.split.map(&:strip).join(' ')
        WARNING: #{target} exists, but is not a symlink to our dotfile
        equivalent.
        ERR
      end
    end

    def existing_link_target(target)
      File.realpath(target)
    rescue Errno::ENOENT
      "[BROKEN LINK]"
    end

    def file_exists_or_is_broken_link?(source, target)
      # File.exist?(target) returns false for an existing but broken link
      return true if File.exist?(target) && File.realpath(target) != source
      return file_is_broken_link?(target)
    end

    def file_is_broken_link?(target)
      # lstat will succeed for broken link, but fail with ENOENT
      # for a truly non-existent file
      begin
        lstat = File.lstat(target)
        if lstat.symlink?
          begin
            # realpath will bail with ENOENT for broken link
            puts "#{target} has a realpath of #{File.realpath(target)}, hence is #{(!(nil != File.realpath(target))).inspect}"
            return !(nil != File.realpath(target))
          rescue Errno::ENOENT
            puts "#{target} is a broken link!"
            return true # this is a broken link
          end
        end
      rescue Errno::ENOENT
          return false # this is a trule not-there file
      end
    end

    # should be two absolute paths by this point
    def create_link(source, target, fail_if_exists=false)
      if File.exist?(target) && File.realpath(target) == source
        # do nothing! this file was already linked
        $stdout.puts "'#{target}' is already linked to '#{source}'"
      elsif file_exists_or_is_broken_link?(source, target)
        puts "#{target} exists or is a broken link"
        if fail_if_exists
          $stderr.puts <<-ERR.split.map(&:strip).join(' ')
          We already tried to fix this existing file at #{target},
          but we appear to have failed. You should look into that.
          ERR
        else
          delete_old_file(source, target)
        end
      else
        # ensure directory exists
        if !Dir.exists?(File.dirname(target))
          $stdout.puts "'#{File.dirname(target)}' doesn't exist. Creating it."
          FileUtils.mkdir_p(File.dirname(target)) unless dry_run?
        end
        $stdout.puts "Linking '#{source}' -> '#{target}'"
        File.symlink(source, target) unless dry_run?
      end
    end

    def install!
      $stdout.puts "Running in dry run mode.\n" if dry_run?

      Dir.chdir File.dirname(__FILE__) do
        manifest.each do |source, options|
          options = validated_options(options)

          sources = Dir.glob(File.expand_path(source))

          if 0 == sources.count
            $stderr.puts WARNING: <<-ERR.split.map(&:strip).join(' ')
            '#{source}' in your manifest did not match any files.
            ERR
          elsif 1 == sources.count
            source = File.expand_path(sources[0])
            # target could be either directory or file
            options['target_is_dir'] = (
              File.extname(options['target']).length > 0 ?
              false :
              true)
            target = target_path(source, options)
            create_link(source, target)
          else
            options['target_is_dir'] = true
            sources.each do |source|
              source = File.expand_path(source)
              target = target_path(source, options)
              create_link(File.expand_path(source), target)
            end
          end
        end
      end
    end
  end

  self.extend StaticMethods
end

DotFilesInstaller.install!
