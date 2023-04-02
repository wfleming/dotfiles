#!/bin/bash
#
# Backup script
# Deps: sudo pacman -S restic

set -e

# construct the b2 URL from secrets & the hostname
destination_url() {
  BUCKET="$(pass backblaze.com/duplicity/bucket)"
  SUBDIR="/restic/$(cat /etc/hostname)"

  printf "s3:${BUCKET}${SUBDIR}\n"
}

run_restic() {
  KEY_ID=$(pass backblaze.com/duplicity/key-id)
  KEY_SECRET=$(pass backblaze.com/duplicity/app-key)

  AWS_ACCESS_KEY_ID="$KEY_ID" AWS_SECRET_ACCESS_KEY="$KEY_SECRET" restic \
    --repo $(destination_url) \
    --password-command "pass restic-passphrase" \
    "$@"
}

init_repository() {
  run_restic init
}

# The approach of "backup the whole home directory but here are some weird
# exclusions" is a bit of patchwork approach. I'm trying to make sure I don't
# forget anything important (and accept I'll end up backing up more than I
# probably really need to), but exclude obviously redundant stuff and
# useless stuff that's big.  For example: my .config/Slack dir is 676M - mostly
# split between cache and service workers. Seems a little excessive. And while
# ~/.cache overall is an obvious "not needed" case, I'm genuinely curious what
# Spotify's cache eviction strategy is, because its cache is currently 11G.
run_backup() {
  run_restic backup \
    --one-file-system \
    --exclude "$HOME/.cache" \
    --exclude "$HOME/.cargo" \
    --exclude "$HOME/.config/Microsoft" \
    --exclude "$HOME/.config/Slack" \
    --exclude "$HOME/.config/chromium" \
    --exclude "$HOME/.config/nvim/tmp" \
    --exclude "$HOME/.dropbox" \
    --exclude "$HOME/.dropbox-dist" \
    --exclude "$HOME/.mozilla" \
    --exclude "$HOME/.rbenv" \
    --exclude "$HOME/.rustup" \
    --exclude "$HOME/.stack" \
    --exclude "$HOME/.zoom" \
    --exclude "$HOME/Dropbox" \
    --exclude "$HOME/mail" \
    --exclude "$HOME/src/custommade" \
    "$HOME"
}

trim_old_snapshots() {
  run_restic forget \
    --keep-last=10 \
    --keep-within=1m \
    --prune
}

case "$1" in
  help)
    cat <<-EOF
		backup.sh - manage laptop backups

		Usage: backup.sh <sub-command>

		Sub-commands:

		    help: Print this help message.
		    dest: Print the B2 destination URL for backups.
		    restic: Stub for restic with repo url & auth passed.
		    init: Initialize remote repository. Must be run before first backup.
		    backup: Run a backup.
		    trim: Trim older snapshots & prune data.
		    backup-and-trim: Run a backup, then trim older snapshots.
		EOF
    ;;
  dest)
    destination_url
    ;;
  restic)
    shift
    run_restic "$@"
    ;;
  init)
    init_repository
    ;;
  backup)
    run_backup
    ;;
  trim)
    trim_old_snapshots
    ;;
  backup-and-trim)
    run_backup
    trim_old_snapshots
    ;;
  '')
    printf "Sub-command required.\n"
    printf "Run '%s help' for available commands.\n" "$0"
    exit 1
    ;;
  *)
    printf "'%s' is not a recognized sub-command.\n" "$1"
    printf "Run '%s help' for available commands.\n" "$0"
    exit 1
    ;;
esac
