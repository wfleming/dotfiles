#!/usr/bin/env ruby
# from http://github.com/mislav/dotfiles/tree/master

home = ENV['HOME']

# symlink basic dotfiles
SKIP_FILES = ['install.rb', 'README.md']
Dir.chdir File.dirname(__FILE__) do
  dotfiles_dir = Dir.pwd
  
  Dir['*'].each do |file|
    next if SKIP_FILES.include?(file)
    target_name = file == 'bin' ? file : ".#{file}"
    target = File.join(home, target_name)
    source = File.join(dotfiles_dir, file)
    if File.exist?(target)
      if !File.lstat(target).symlink? || File.realpath(target) != source
        puts "DEBUG source is #{source}, realpath is #{}"
        $stderr.puts "WARNING: #{target} exists, but is not a symlink to our dotfile equivalent"
      end
    else
      system %[ln -vsf #{source} #{target}]
    end
  end
end
