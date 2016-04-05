if command -v gpg-agent > /dev/null 2>&1; then
  export GPG_TTY=$(tty)
  if [ -f "${HOME}/.gpg-agent-info" ]; then
    source "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
  else
    gpg-agent --daemon --write-env-file "${HOME}/.gpg-agent-info"
  fi
fi
