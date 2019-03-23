#!/bin/sh
#
# Install dotfiles symlinks in /etc.
# Kept separate from home config management in install.sh since mucking with
# /etc requires sudo and is hence a bit riskier and likely to be done more
# carefully/after other system setup.
#
# USAGE:
# Just run it from `dotfiles`, e.g. `./etc/install.sh`
#
# Run with `-n` to see a dry run of what the script will do.
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

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

############# DO THE LINKING #############

for f in $(find ./etc -type f -not -name install.sh); do
  rel_target=$(realpath --relative-to="$PWD" "$f")
  link "$(realpath "$f")" "/$rel_target"
done

