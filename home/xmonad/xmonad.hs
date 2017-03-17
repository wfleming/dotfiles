module Main (main) where

import System.Taffybar.Hooks.PagerHints (pagerHints)
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig (additionalKeysP)

baseConfig = desktopConfig

-- The default, except no borders in fullscreen or when only one window
-- see https://github.com/xmonad/xmonad/blob/master/src/XMonad/Config.hs
layouts = smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

main :: IO ()
main = xmonad $
    ewmh $
    pagerHints $
    baseConfig
      { borderWidth = 4
      , terminal = "urxvt"
      , modMask = mod4Mask
      , normalBorderColor = "#333333"
      , focusedBorderColor = "#FFBF00"
      , manageHook = manageDocks <+> manageHook baseConfig
      , layoutHook = avoidStruts $ layouts
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
