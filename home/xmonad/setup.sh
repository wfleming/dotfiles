#!/bin/sh
set -e

# As of 2018-01-22 it's necessary to patch ghc settings locally on Arch for this
# to work with stack-static, see
# https://github.com/commercialhaskell/stack/issues/2712

git clone git@github.com:wfleming/taffybar.git vendor/taffybar

stack install alex
stack install happy
stack install gtk2hs-buildtools
stack install xmonad
stack install taffybar

stack build
