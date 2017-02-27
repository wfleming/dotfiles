module Main (main) where

import System.Taffybar.Hooks.PagerHints (pagerHints)
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeysP)

baseConfig = desktopConfig

main :: IO ()
main = xmonad $
    ewmh $
    pagerHints $
    baseConfig
      { terminal = "urxvt"
      , modMask = mod4Mask
      , normalBorderColor = "#333333"
      , focusedBorderColor = "#999999"
      , manageHook = manageDocks <+> manageHook baseConfig
      , layoutHook = avoidStruts $ layoutHook baseConfig
      } `additionalKeysP`
        [ ("M-S-l", spawn "slock")
        , ("M-S-s", spawn "scrot -s")
        , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 3+")
        , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 3-")
        , ("<XF86AudioMute>", spawn "amixer sset Master toggle")
        , ("<XF86AudioMicMute>", spawn "amixer sset Capture toggle")
        , ("<XF86AudioPlay>", spawn "spotify-control playpause")
        , ("<XF86AudioNext>", spawn "spotify-control next")
        , ("<XF86AudioPrev>", spawn "spotify-control previous")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
        ]
