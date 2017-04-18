###### ALIASES #####

alias v=vim
alias ls='ls -F --color=auto'
alias ll='ls -AFhl'

alias cca='codeclimate analyze'
alias pacman-rm-orphans='sudo pacman -Rsn $(pacman -Qqdt)'

####### FUNCTIONS ##########

# Shorten git to one letter, execute status by default if no
# subcommand is specified
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}

# make copies of all *.example files in the current directory
# without .example extension
deexample() {
 for f in *.example; do
   cp $f `echo $f | sed s/.example//`
 done
}

# It would seem my thinkpads don't have motherboard speakers, so
# `echo -e "\a"` doesn't work
beep() {
  ( speaker-test -t sine -f 800 > /dev/null )& pid=$!
  sleep 0.05s
  kill -9 $pid > /dev/null
}

# top history
tophist() {
  cat ~/.zsh_history \
    | cut -d ';' -f 2- 2>/dev/null \
    | awk '{a[$1]++ } END{for(i in a){print a[i] " " i}}' \
    | sort -rn \
    | head
}
