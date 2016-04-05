#!/bin/bash -e
#
# Updates Vim plugins.
# Adapted from https://github.com/statico/dotfiles/blob/master/.vim/update.sh
#
# Update everything (long):
#
#   ./update.sh
#
# Update just the things from Git:
#
#   ./update.sh repos
#
# Update just one plugin from the list of Git repos:
#
#   ./update.sh repos powerline
#

cd ~

vimdir=$PWD/.vim
bundledir=$vimdir/bundle
tmp=/tmp/$LOGNAME-vim-update
me=.vim/update.sh

# URLS --------------------------------------------------------------------

# This is a list of all plugins which are available via Git repos. git:// URLs
# don't work.
repos=(
# auditing these color schemes
  http://github.com/pbrisbin/vim-colors-off.git
  https://github.com/robertmeta/nofrils.git

  https://github.com/ap/vim-css-color.git
  https://github.com/bling/vim-airline.git
  https://github.com/docunext/closetag.vim.git
  https://github.com/fatih/vim-go.git
  https://github.com/kien/ctrlp.vim.git
  https://github.com/rking/ag.vim.git
  https://github.com/scrooloose/nerdcommenter.git
  https://github.com/scrooloose/nerdtree.git
  https://github.com/slim-template/vim-slim.git
  https://github.com/tpope/vim-fugitive.git
  https://github.com/tpope/vim-sensible.git
  https://github.com/tpope/vim-surround.git
  https://github.com/vim-ruby/vim-ruby.git

  )

# Here's a list of everything else to download in the format
# <destination>;<url>[;<filename>]
other=(

  )

mode=$1
if [ -z "$mode" ]; then
  mode="all"
fi

case "$mode" in

  # GIT -----------------------------------------------------------------
  repos|repo)
    mkdir -p $bundledir
    mkdir -p $vimdir/tmp
    for url in ${repos[@]}; do
      if [ -n "$2" ]; then
        if ! (echo "$url" | grep "$2" &>/dev/null) ; then
          continue
        fi
      fi
      dest="$bundledir/$(basename $url | sed -e 's/\.git$//')"
      rm -rf $dest
      echo "Cloning $url into $dest"
      git clone -q $url $dest
      rm -rf $dest/.git
    done
    ;;

  # TARBALLS AND SINGLE FILES -------------------------------------------
  other)
    set -x
    mkdir -p $bundledir
    mkdir -p $vimdir/tmp
    rm -rf $tmp
    mkdir $tmp
    pushd $tmp

    for pair in ${other[@]}; do
      parts=($(echo $pair | tr ';' '\n'))
      name=${parts[0]}
      url=${parts[1]}
      filename=${parts[2]}
      dest=$bundledir/$name

      rm -rf $dest

      if echo $url | egrep '.zip$'; then
        # Zip archives from VCS tend to have an annoying outer wrapper
        # directory, so unpacking them into their own directory first makes it
        # easy to remove the wrapper.
        f=download.zip
        $curl -L $url >$f
        unzip $f -d $name
        mkdir -p $dest
        mv $name/*/* $dest
        rm -rf $name $f

      else
        # Assume single files. Create the destination directory and download
        # the file there.
        mkdir -p $dest
        pushd $dest
        if [ -n "$filename" ]; then
          $curl -L $url >$filename
        else
          $curl -OL $url
        fi
        popd

      fi

    done

    popd
    rm -rf $tmp
    ;;

  # HELP ----------------------------------------------------------------

  all)
    $me repos
    $me other
    echo
    echo "Update OK"
    ;;

  *)
    set +x
    echo
    echo "Usage: $0 <section> [<filter>]"
    echo "...where section is one of:"
    grep -E '\w\)$' $me | sed -e 's/)//'
    echo
    echo "<filter> can be used with the 'repos' section."
    exit 1

esac
