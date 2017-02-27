#!/bin/sh
set -e

git clone git@github.com:wfleming/taffybar.git vendor/taffybar

stack install xmonad
stack install taffybar

stack build
