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
  sleep 0.25s
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

genpass() {
  < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;
}

pass-store-backup() {
  dir=${1:-passwords-backup}

  printf "Backing up passwords to %s\n" "$dir"

  IFS=$'\n' # passwords can have spaces in names (though I should probably avoid that)
  for e in $(pass git ls-files | grep '\.gpg$'); do
    ebase=${e%.*}
    dest="$dir/${ebase}.txt"
    mkdir -p "$(dirname "$dest")"
    pass show "$ebase" > "$dest"
  done

  echo "Done."
}

pass-dump() {
  echo "Will's passwords\n\n"
  echo "-------------------\n"

  IFS=$'\n' # passwords can have spaces in names (though I should probably avoid that)
  for e in $(pass git ls-files | grep '\.gpg$'); do
    ebase=${e%.*}
    printf "Entry: %s\n\n" "$ebase"
    pass show "$ebase"
    echo "\n-------------------\n"
  done
}

gifcast() {
  coords=$(slurp)
  out="$HOME/gifcast_$(date +%y%m%d%H%M%S).gif"
  wf-recorder --geometry "$coords" --codec gif -f "$out"
}
