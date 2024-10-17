if [[ "$PATH" != *".rbenv/shims"* ]]; then
  if command -v rbenv > /dev/null; then
    eval "$(rbenv init - zsh)"
  fi
fi
