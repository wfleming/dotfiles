# include brew paths in PATH before system paths
export PATH="$HOME/bin:$HOME/local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"

# Load zsh module config files
for config_file ($HOME/.zsh/**/*.zsh) source $config_file
