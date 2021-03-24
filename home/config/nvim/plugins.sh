#!/bin/bash
#
# Updates Vim plugins.
# Adapted from https://github.com/statico/dotfiles/blob/master/.vim/update.sh
#
# Update everything (long):
#
#   ./update.sh
set -e

cd ~/.config/

vimdir="$PWD/nvim"
bundledir="$vimdir/bundle"

# URLS --------------------------------------------------------------------

# This is a list of all plugins which are available via Git repos. git:// URLs
# don't work.
repos=(
  https://github.com/ap/vim-css-color.git
  https://github.com/JuliaEditorSupport/julia-vim.git
  https://github.com/bling/vim-airline.git
  https://github.com/elixir-lang/vim-elixir.git
  https://github.com/fatih/vim-go.git
  https://github.com/morhetz/gruvbox.git
  https://github.com/junegunn/fzf.vim.git
  https://github.com/scrooloose/nerdtree.git
  https://github.com/slim-template/vim-slim.git
  https://github.com/tpope/vim-commentary.git
  https://github.com/tpope/vim-fugitive.git
  https://github.com/tpope/vim-rhubarb.git
  https://github.com/tpope/vim-surround.git
)

# FUNCTIONS --------------------------------------------------------------

# args: url
repo_dest() {
  dest="$bundledir/$(basename "$1" | sed -e 's/\.git$//')"
  printf "%s\n" "$dest"
}

# RUN --------------------------------------------------------------------

mode=$1
if [ -z "$mode" ]; then
  mode="repos"
fi

case "$mode" in
  # GIT -----------------------------------------------------------------
  repos|repo)
    mkdir -p "$bundledir"
    for url in "${repos[@]}"; do
      if [ -n "$2" ]; then
        if ! (printf "%s\n" "$url" | grep "$2" &>/dev/null) ; then
          continue
        fi
      fi
      dest=$(repo_dest "$url")
      rm -rf "$dest"
      printf "Cloning %s into %s\n" "$url" "$dest"
      git clone -q "$url" "$dest"
      rm -rf "$dest/.git"
    done
    ;;

  # ORPHANS -------------------------------------------------------------
  orphans)
    for d in $bundledir/*; do
      is_orphaned=1
      for url in "${repos[@]}"; do
        if [ "$bundledir/$(basename "$d")" = "$(repo_dest "$url")" ]; then
          is_orphaned=0
          break
        fi
      done
      if [ -L "$d" ]; then
        is_orphaned=0
      fi
      if [ "1" == "$is_orphaned" ]; then
        printf "%s\n" "$d"
      fi
    done
    ;;

  # HELP ----------------------------------------------------------------
  *)
    cat <<EOF
  Usage:

    $0                  Clone all plugins
    $0 repo <names>...  Clone specified plugins
    $0 orphans          List orphaned plugins (installed but not listed)
EOF
    ;;
esac
