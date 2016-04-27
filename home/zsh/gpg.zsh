if command -v gpg-agent > /dev/null 2>&1; then
  GPG_TTY=$(tty)
  export GPG_TTY
  if [ -f "/tmp/gpg-agent-info" ]; then
    source "/tmp/gpg-agent-info"
    export GPG_AGENT_INFO
  else
    eval "$(gpg-agent --daemon)"
  fi
fi
