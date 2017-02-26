#!/bin/sh
set -e

stack install xmonad
stack build

# TODO: clone taffybar to vendor/taffybar & install it as well.
