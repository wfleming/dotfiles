#!/bin/sh
set -e

# As of 2018-01-22 it's necessary to patch ghc settings locally on Arch for this
# to work with stack-static, see
# https://github.com/commercialhaskell/stack/issues/2712

if [ ! -d vendor/taffybar ]; then
  git clone git@github.com:wfleming/taffybar.git vendor/taffybar
fi

stack_install() {
  printf "==== stack install %s ====\n" "$1"
  stack install "$1"
}

stack_install alex
stack_install happy
stack_install gtk2hs-buildtools
stack_install xmonad
stack_install taffybar

echo "==== stack build ===="
stack build
