# Set vars that will affect desktop env but aren't generally needed elsewhere
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then
  # so JetBrains IDEs will behave themselves
  # https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers
  export _JAVA_AWT_WM_NONREPARENTING=1
fi

