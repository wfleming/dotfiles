if [[ "$PATH" != *".rbenv/shims"* ]]; then
  eval "$(rbenv init - zsh)"
  # for Bundler/Rails stubs
  export PATH=".bundle/bin:$PATH"
fi
