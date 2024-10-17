# dotfiles

These are configurations files & scripts I use for my laptop. This branch is for an installation of
[Asahi Linux], but a lot of it is applicable to any \*nix distro.

## My workflow

To help indicate if any aspects of my configuration may be useful for you, I'll
try to give a brief overview of my overall approach. I'm biased towards simple
tools, often glued together with shell scripts, and terminal-based when
feasible. A brief overview of the key tools I use:

- [sway][] for my window manager. Tiling window managers are the only true window
  managers.
- I spend most of my time in [tmux][] sessions in [foot][].
- My text editor is [Neovim][].
- I read & write mail with [NeoMutt][], use [OfflineIMAP][] to sync mail, and
  send mail with [msmtp][]. (I did say I preferred terminal-based tools.)

[Asahi Linux]: https://asahilinux.org/
[sway]: https://github.com/swaywm/sway
[Neovim]: https://neovim.io/
[tmux]: https://github.com/tmux/tmux/wiki
[foot]: https://codeberg.org/dnkl/foot
[NeoMutt]: https://neomutt.org/
[OfflineIMAP]: https://www.offlineimap.org/
[msmtp]: https://marlam.de/msmtp/

## Organization & usage

The bulk of this repository is for contents of my home directory. These files
are organized under `home` and `home_nodot`, and are installed with
`install.sh`.

System-wide configurations are under `system`, and are installed with
`system/install.sh` (which must be run as root).

`new-machine` contains scripts for setting up a new machine.

`manual` contains some notes on preferred configuration I haven't figured out
how to (or bothered to) automate yet.
