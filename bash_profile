# Bash color definitions
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
txtrst='\e[0m'    # Text Reset

# format prompt to include git branch if available
parse_git_branch () {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}
export PS1="\[$txtgrn\]\w\[$txtrst\]:\[$txtred\]\$(parse_git_branch)\[$txtgrn\]\$\[$txtrst\]"


# Aliases
alias cpwd='pwd|xargs echo -n|pbcopy'
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'
alias gpf='git push-feature'
alias memcachedstatus='echo stats | nc 127.0.0.1 11211'

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
