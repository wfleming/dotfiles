###### ALIASES #####

alias cpwd='pwd|xargs echo -n|pbcopy'
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

alias ls='ls -FG'
alias ll='ls -AFGl'

# gc & go are used by go-lang. sigh.
# alias gs='git st'
# alias gp='git push'
# alias gc='git commit'
# alias go='git checkout'

alias memcachedstatus='echo stats | nc 127.0.0.1 11211'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

alias rc='rails c'
alias rdb='rails db'
alias rg='rails g'
alias bi='bundle install'
alias be='bundle exec'
alias dbm='rake db:migrate'
alias dbmr='rake db:migrate:redo'
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

# shortcut for loading boot2docker env vars as needed.
# accepts --quiet flag to supress output
function b2denv {
  local pipe_stderr=""
  if [[ $1 = "--quiet" ]]; then
    pipe_stderr="2>/dev/null"
  fi
  echo "pipe_stderr $pipe_stderr"
  local cmd="boot2docker shellinit $pipe_stderr"
  echo $cmd
  eval $($cmd)
}

# Add an ip to the MintWhitelist for a certain project
# Usage: add-whitelist-ip 'jelmer' 'my-ip'
# Optionally, you can add the app name.
# This only works with heroku projects
function add-whitelist-ip {
    KEY=$1
    IP=$2
    if [[ "$KEY" == "" ]] || [[ "$IP" == "" ]]
    then
        echo "add-whitelist-ip <key> <ip> [heroku-name]"
    else
        if [[ "$3" == "" ]]
        then
            APP=$(--app $3)
        else
            APP=''
        fi

        bundle exec heroku run rails runner "MintWhitelist::Ip.create\(\'$KEY\',\'$IP\'\)" $APP
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
 for f in *.example; do
   cp $f `echo $f | sed s/.example//`
 done
}

# top history
function tophist {
  cat ~/.zsh_history|cut -d ';' -f 2- 2>/dev/null| awk '{a[$1]++ } END{for(i in a){print a[i] " " i}}'|sort -rn|head
}
