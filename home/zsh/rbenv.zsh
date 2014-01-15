export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="./bin:./bundler_bin:$PATH" # a bit dangerous, maybe, but makes bundler stubs much easier to work with
source "$HOME/.rbenv/completions/rbenv.zsh"
rbenv rehash 2>/dev/null
