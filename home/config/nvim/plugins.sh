#!/bin/bash
#
# Updates Vim plugins.
# Adapted from https://github.com/statico/dotfiles/blob/master/.vim/update.sh
#
# Update everything (long):
#
#   ./update.sh
set -e

vimdir="$(dirname $0)"
packstartdir="$vimdir/pack/packages/start"

# URLS --------------------------------------------------------------------

# This is a list of all plugins which are available via Git repos. git:// URLs
# don't work.
repos=(
  https://github.com/ap/vim-css-color.git
  https://github.com/bling/vim-airline.git
  https://github.com/elixir-lang/vim-elixir.git
  https://github.com/morhetz/gruvbox.git
  https://github.com/junegunn/fzf.vim.git
  https://github.com/tpope/vim-commentary.git
  https://github.com/tpope/vim-fugitive.git
  https://github.com/tpope/vim-rhubarb.git
  https://github.com/tpope/vim-surround.git
  https://github.com/tpope/vim-obsession.git
  https://github.com/neoclide/coc.nvim.git@release
)

# FUNCTIONS --------------------------------------------------------------

# args: url
repo_dest() {
  dest="$packstartdir/$(basename "$1" | sed -e 's/\.git.*$//')"
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
    mkdir -p "$packstartdir"
    for url in "${repos[@]}"; do
      if [ -n "$2" ]; then # support repo <name>: skip unless match
        if ! (printf "%s\n" "$url" | grep "$2" &>/dev/null) ; then
          continue
        fi
      fi
      other_args=""
      # support url@branch to specify branch
      if [[ "$url" == *"@"* ]]; then
        real_url=$(printf "$url" | sed -e 's/\(.*\)@.*/\1/')
        branch=$(printf "$url" | sed -e 's/.*@\(.*\)/\1/')
        other_args="-b $branch"
        url=$real_url
      fi
      dest=$(repo_dest "$url")
      rm -rf "$dest"
      printf "Cloning %s into %s\n" "$url" "$dest"
      git clone --template=/usr/share/git-core/templates -q $other_args "$url" "$dest"
      rm -rf "$dest/.git"
    done
    ;;

  # GIT -----------------------------------------------------------------
  docs)
    find "$packstartdir" -name doc | xargs -I '{}' -n1 vim -c "helptags {}" -c quit
    ;;

  # ORPHANS -------------------------------------------------------------
  orphans)
    for d in $packstartdir/*; do
      is_orphaned=1
      for url in "${repos[@]}"; do
        if [ "$packstartdir/$(basename "$d")" = "$(repo_dest "$url")" ]; then
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
    $0 repo <name>...   Clone specified plugin
    $0 orphans          List orphaned plugins (installed but not listed)
EOF
    ;;
esac
