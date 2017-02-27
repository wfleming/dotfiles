#!/bin/sh
set -e

git clone git@github.com:wfleming/taffybar.git vendor/taffybar

stack install alex
stack install gtk2hs-buildtools
stack install xmonad
stack install taffybar

stack build
