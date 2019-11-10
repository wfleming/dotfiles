alias cpwd='pwd|xargs echo -n|pbcopy'
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

alias ls='ls -FG'
alias ll='ls -AFGl'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

alias beep="echo -ne '\007'"
alias cca='codeclimate analyze'
alias vim=nvim

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

# display a man page in Preview
pdfman () {
  man -t $1 | open -a /Applications/Preview.app -f
}

# top history
function tophist {
  cat ~/.zsh_history|cut -d ';' -f 2- 2>/dev/null| awk '{a[$1]++ } END{for(i in a){print a[i] " " i}}'|sort -rn|head
}
