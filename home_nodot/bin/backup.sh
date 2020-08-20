#!/bin/sh
#
# Backup script
# Deps: sudo pacman -S duplicity python-pip; sudo pip install b2sdk

set -e

# construct the b2 URL from secrets & the hostname
destination_url() {
  BUCKET=$(pass backblaze.com/duplicity/bucket)
  SUBDIR=$(cat /etc/hostname)
  KEY_ID=$(pass backblaze.com/duplicity/key-id)
  KEY_SECRET=$(pass backblaze.com/duplicity/app-key)

  printf "b2://${KEY_ID}:${KEY_SECRET}@${BUCKET}/${SUBDIR}\n"
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
  duplicity \
    --encrypt-key "<will@flemi.ng>" \
    --exclude-other-filesystems \
    --exclude "$HOME/.cache" \
    --exclude "$HOME/.cargo" \
    --exclude "$HOME/.config/Microsoft" \
    --exclude "$HOME/.config/Slack" \
    --exclude "$HOME/.config/chromium" \
    --exclude "$HOME/.config/nvim/tmp" \
    --exclude "$HOME/.dropbox" \
    --exclude "$HOME/.dropbox-dist" \
    --exclude "$HOME/.m2" \
    --exclude "$HOME/.mozilla" \
    --exclude "$HOME/.rbenv" \
    --exclude "$HOME/.rustup" \
    --exclude "$HOME/.zoom" \
    --exclude "$HOME/Dropbox" \
    --exclude "$HOME/SpiderOak Hive" \
    --exclude "$HOME/mail" \
    --exclude "$HOME/src/cc" \
    --full-if-older-than 1M \
    --progress \
    --progress-rate 300 \
    "$HOME" \
    $(destination_url)
}

# Delete older backup sets.
# I schedule this to run daily, so the idea is that I'll do daily incremental
# backups, automatically starting a new full backup every month, and this
# command will remove the older sets so I'll always have my most recent full
# backup (plus daily incrementals), plus the backup from before that (in case
# something goes haywire with the most recent one), and delete anything older
# than that.
clean_old() {
  duplicity \
    remove-all-but-n-full 2 \
    --force \
    $(destination_url)
}

case "$1" in
  help)
    cat <<-EOF
		backup.sh - manage laptop backups

		Usage: backup.sh <sub-command>

		Sub-commands:

		    help: Print this help message.
		    dest: Print the B2 destination URL (with authentication) for backups.
		    run: Run a backup.
		    clean: Delete older, stale backups.
		    run-and-clean: Execute run & clean sub-commands in sequence.
		EOF
    ;;
  dest)
    destination_url
    ;;
  run)
    run_backup
    ;;
  clean)
    clean_old
    ;;
  run-and-clean)
    run_backup
    clean_old
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
