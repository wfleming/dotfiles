autoload -U colors && colors
setopt prompt_subst

PROMPT='%{$fg[green]%}[%c] %{$reset_color%} '
GIT_PROMPT='%{$fg[green]%}$(git_prompt_info)%{$reset_color%}'
RPS1="$GIT_PROMPT"

# show VI insert mode
function zle-line-init zle-keymap-select {
  VIM_MODE="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_MODE}/(main|viins)/} $GIT_PROMPT $EPS1"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
