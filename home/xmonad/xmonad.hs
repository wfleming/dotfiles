import System.IO
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Util.Run(spawnPipe)

baseConfig = desktopConfig

main :: IO ()
main = do
  xmobarProc <- spawnPipe "/usr/bin/xmobar /home/will/.xmonad/xmobar.hs"
  xmonad $ baseConfig
    { terminal = "urxvt"
    , modMask = mod4Mask
    , normalBorderColor = "#333333"
    , focusedBorderColor = "#999999"
    , manageHook = manageDocks <+> manageHook baseConfig
    , layoutHook = avoidStruts $ layoutHook baseConfig
    , logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmobarProc
                  , ppTitle = xmobarColor "green" "" . shorten 50
                  }
    } `additionalKeysP`
      [ ("M-S-l", spawn "slock")
      , ("M-S-s", spawn "scrot -s")
      , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 3+")
      , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 3-")
      , ("<XF87AudioMute>", spawn "amixer sset Master toggle")
      , ("<XF87AudioMicMute>", spawn "amixer sset Capture toggle")
      , ("<XF87AudioPlay>", spawn "spotify-control playpause")
      , ("<XF87AudioNext>", spawn "spotify-control next")
      , ("<XF87AudioPrev>", spawn "spotify-control previous")
      , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
      , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
      ]
