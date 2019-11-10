#!/bin/sh
#
# Install dotfiles symlinks in $HOME
#
# USAGE:
# Just run it.
#
# Run with `-n` to see a dry run of what the script will do.
set -e

############# SETUP: variables, flags #############
colorR=$(tput setaf 1)
colorG=$(tput setaf 2)
nocolor=$(tput sgr0)

dry_run=0

while getopts ":n" opt; do
 case $opt in
    n)
      dry_run=1;;
    "?")
      printf "Invalid option -%s\n" "$OPTARG"
      exit 64;;
    ":")
      printf "Option -%s requires an argument\n" "$OPTARG"
      exit 64;;
  esac
done

############# FUNCTIONS #############

warn() {
  printf "%s%s%s\n" "$colorR" "$1" "$nocolor"
}

success() {
  printf "%s%s%s\n" "$colorG" "$1" "$nocolor"
}

# ARGS: (source, dest)
link() {
  if [ -e "$2" ]; then
    if [ "$(realpath "$2")" = "$1" ]; then
      echo "$1 is already linked to $2"
    else
      warn "Cannot link $1 to $2: destination exists"
    fi
  elif [ "$dry_run" = 1 ]; then
    success "[DRY RUN] Would link $1 to $2"
  else
    if ln -s "$1" "$2"; then
      success "Linked $1 to $2"
    else
      warn "Failed to link $1 to $2"
    fi
  fi
}

# ARGS (source, base_target, prefix)
target_path() {
  printf "%s/%s%s" "$2" "$3" "$(basename "$1")"
}

############# DO THE LINKING #############

for f in home/*; do
  link "$(realpath "$f")" "$(target_path "$f" "$HOME" ".")"
done

for f in home_nodot/*; do
  link "$(realpath "$f")" "$(target_path "$f" "$HOME")"
done
