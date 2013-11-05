###### ALIASES #####

alias cpwd='pwd|xargs echo -n|pbcopy'
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

alias ls='ls -FG'
alias ll='ls -AFGl'

alias gu='git up'
alias gs='git st'
alias gc='git commit'
alias go='git checkout'

alias memcachedstatus='echo stats | nc 127.0.0.1 11211'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

alias rc='rails c'
alias rdb='rails db'
alias rg='rails g'
alias be='bundle exec'
alias dbm='rake db:migrate'
alias dbmr='rake db:migrate:redo'
alias dbtp='rake db:test:prepare'
alias kick_spin="kicker -r rails . -b 'spin push'"
alias beep="echo -ne '\007'"



####### FUNCTIONS ##########

# Shorten git to one letter, execute status by default if no
# subcommand is specified
function g {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}

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

# make copies of all *.example files in the current directory
# without .example extension
deexample() {
 for f in `ls *.example`; do
   cp $f `echo $f | sed s/.example//`
 done
}

# top history
function tophist {
    cat ~/.bash_history | awk '{CMD[$1]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}
