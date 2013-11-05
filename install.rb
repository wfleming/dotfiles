#!/usr/bin/env ruby
# from http://github.com/mislav/dotfiles/tree/master

home = ENV['HOME']

# symlink basic dotfiles
SKIP_FILES = ['install.rb', 'README.md']
Dir.chdir File.dirname(__FILE__) do
  dotfiles_dir = Dir.pwd.sub(home + '/', '')

  Dir['*'].each do |file|
    next if SKIP_FILES.include?(file)
    target_name = file == 'bin' ? file : ".#{file}"
    target = File.join(home, target_name)
    unless File.exist? target
      system %[ln -vsf #{File.join(dotfiles_dir, file)} #{target}]
    end
  end
end
