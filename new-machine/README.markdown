# Machine setup scripting

Asahi Linux installation doesn't seem easily scriptable from scratch given the constraints around
setup on a Mac, so for setup I manually run through Asahi's official installer (using the "minimal"
preset since I won't be using GNOME or KDE), setup my user account that way. Then on first login, I
install git, clone this repository, and run `sudo new-machine/setup`.
