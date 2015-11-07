autoload colors; colors;
setopt prompt_subst

PROMPT='%{$fg[green]%}[%c] %{$reset_color%} '
RPROMPT='%{$fg[green]%}$(git_prompt_info) $(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="💩"
ZSH_THEME_GIT_PROMPT_CLEAN="✨"
ZSH_THEME_GIT_PROMPT_ADDED="✈️"
ZSH_THEME_GIT_PROMPT_MODIFIED="" #"{$fg[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_DELETED="❌"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂️"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%} ✱"


# escape sequences for OS X terminal to enable opening tabs with same directory
precmd () {print -Pn "\e]2; %~/ \a"}
preexec () {print -Pn "\e]2; %~/ \a"}
