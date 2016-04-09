if command -v gpg-agent > /dev/null 2>&1; then
  GPG_TTY=$(tty)
  export GPG_TTY
  if [ -f "${HOME}/.gnupg/gpg-agent-info" ]; then
    source "${HOME}/.gnupg/gpg-agent-info"
    export GPG_AGENT_INFO
  else
    eval "$(gpg-agent --daemon --write-env-file "${HOME}/.gnupg/gpg-agent-info")"
  fi
fi
