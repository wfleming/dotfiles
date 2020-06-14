# I generally start sway manually from tty1 after login
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
  # I am still running X sometimes as well, so these will also apply there, but
  # they don't seem harmful? FF drops back to X smoothly even with this ENV set,
  # the NONREPARENTING thing has more to do with using tiling window managers
  # than the GUI, and the JDK change is fine as well.

  # so JetBrains IDEs will behave themselves
  # https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers
  export _JAVA_AWT_WM_NONREPARENTING=1
  # https://github.com/swaywm/sway/wiki#issues-with-java-applications
  export DATAGRIP_JDK=/usr/lib/jvm/java-11-openjdk
  # so ff will use wayland renderer (see "Window protocol" in about:support to confirm)
  export  MOZ_ENABLE_WAYLAND=1
fi
