# Set vars that will affect desktop env but aren't generally needed elsewhere
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
  # so JetBrains IDEs will behave themselves
  # https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers
  export _JAVA_AWT_WM_NONREPARENTING=1
  # https://github.com/swaywm/sway/wiki#issues-with-java-applications
  export DATAGRIP_JDK=/usr/lib/jvm/java-11-openjdk
fi

