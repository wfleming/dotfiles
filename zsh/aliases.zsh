###### ALIASES #####

alias cpwd='pwd|xargs echo -n|pbcopy'
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'

alias ls='ls -FG'
alias ll='ls -AFGl'

alias gc='git commit'
alias go='git checkout'
alias gpf='git push-feature'

alias memcachedstatus='echo stats | nc 127.0.0.1 11211'

alias rc='rails c'
alias rdb='rails db'
alias rg='rails g'
alias be='bundle exec'
alias dbm='rake db:migrate'
alias dbmr='rake db:migrate:redo'
alias dbtp='rake db:test:prepare'


####### FUNCTIONS ##########

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

# from http://gist.github.com/634946
# Opens `https://github.com/<repo>/blob/<branch>/public/javascripts/app.js`
# in your browser.
#TODO - this is broken with current github URL structure
hubb(){
  repo=$(git config remote.origin.url | sed "s/^git@github\.com:\(.*\)\.git$/\1/")
  branch=$(cat .git/HEAD | sed "s/.*\/\(.*\)$/\1/")
  kind=$([[ $1 =~ \/$ ]] && echo "tree" || echo "blob")
  open "https://github.com/$repo/$kind/$branch/$1"
}