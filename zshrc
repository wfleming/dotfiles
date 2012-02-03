# import the RVM environment stuff
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi

# include brew paths in PATH before system paths
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# include android tools in path
export ANDROID_SDK_ROOT=/Applications/Installed/android-sdk-mac_x86
export PATH=$PATH:$ANDROID_SDK_ROOT/tools

# include Firefox in the PATH for selenium/pyrite
export PATH=$PATH:/Applications/Installed/Firefox.app/Contents/MacOS

# include jake in the PATH for node
export PATH=$PATH:/usr/local/share/npm/bin
# make sure npm-installed modules easily requirable in node
export NODE_PATH=/usr/local/lib/node/

export PATH=$PATH:~/bin
export EDITOR='mate -w'


#function for staging log messages
staginglog() {
  git log --pretty="* %s [%an, %h]" $1...HEAD
}

#search for file by name in spotlight
spotlightfile() {
    mdfind "kMDItemDisplayName == '$@'wc";
}

# Search for file by contenti in spotlight
spotlightcontent() {
    mdfind -interpret "$@";
}

# display a man page in Preview
pdfman () {
    man -t $1 | open -a /Applications/Preview.app -f
}

# from http://gist.github.com/634946
# Opens `https://github.com/<repo>/blob/<branch>/public/javascripts/app.js`
# in your browser.
hubb(){
  repo=$(git config remote.origin.url | sed "s/^git@github\.com:\(.*\)\.git$/\1/")
  branch=$(cat .git/HEAD | sed "s/.*\/\(.*\)$/\1/")
  kind=$([[ $1 =~ \/$ ]] && echo "tree" || echo "blob")
  open "https://github.com/$repo/$kind/$branch/$1"
}


# Mint staging/dev servers
bp() {
    ssh mint@briarpatch-0${1}.vm.brightbox.net
}
by() {
    ssh mint@briaryear-0${1}.vm.brightbox.net
}
ms() {
  ssh mintstaging-0${1}.vm.brightbox.net
}


# Load zsh module config files
for config_file ($HOME/.zsh/*.zsh) source $config_file
