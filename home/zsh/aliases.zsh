###### ALIASES #####

alias ls='ls -FG'
alias ll='ls -AFGl'

alias rc='rails c'
alias rdb='rails db'
alias rg='rails g'
alias bi='bundle install'
alias be='bundle exec'
alias dbm='rake db:migrate'
alias beep="echo -ne '\007'"
alias cca='codeclimate analyze'

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
