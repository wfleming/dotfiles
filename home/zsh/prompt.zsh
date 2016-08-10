autoload colors; colors;
setopt prompt_subst

PROMPT='%{$fg[green]%}[%c] %{$reset_color%} '
GIT_PROMPT='%{$fg[green]%}$(git_prompt_info) $(git_prompt_status)%{$reset_color%}'
RPS1="$GIT_PROMPT"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[brown]%}☃"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✦"
ZSH_THEME_GIT_PROMPT_ADDED="⨁"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}⨂"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➔"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}☈"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}✱"

# show VI insert mode
function zle-line-init zle-keymap-select {
  VIM_MODE="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_MODE}/(main|viins)/} $GIT_PROMPT $EPS1"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
