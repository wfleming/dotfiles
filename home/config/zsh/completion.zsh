unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

WORDCHARS=''

autoload -U compinit
compinit -i

# aliases need to be listed for completion to work
compdef g=git

zmodload -i zsh/complist

# case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# tab complete some custom git sub-commands
# I found the details about this in /usr/share/zsh/functions/Completion/Unix/_git
# for some reason the `compdef` above doesn't apply to these, so they're defined twice
git_user_cmds=(
  jira-branch:'Checkout branch for a jira ticket'
  prune-branches:'Delete branches already merged into master'
  cleanup-branches:'Interactive mass-delete branches'
)
zstyle ':completion:*:*:git:*' user-commands $git_user_cmds
zstyle ':completion:*:*:g:*' user-commands $git_user_cmds
