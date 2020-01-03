import XMonad
import XMonad.Config.Azerty
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Spacing



main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "xmobar -f xft:Monoid:size=10:bold:antialias=true -A 200"

-- myPP: what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#42b942" "" . wrap "{" "}"
    -- display other workspaces which contain windows as a brighter grey
    , ppHidden          = xmobarColor "#6666ee" "" . pad

    -- display other workspaces with no windows as a normal grey
    , ppHiddenNoWindows = xmobarColor "#606060" "" . pad

    -- display the current layout as a brighter grey
    , ppLayout          = xmobarColor "#6464ff" "" . pad

    -- if a window on a hidden workspace needs my attention, color it so
    , ppUrgent          = xmobarColor "#ff0000" "" . pad . xmobarStrip

    -- shorten if it goes over 30 characters
    , ppTitle           = shorten 20

    -- separator between workspaces
    , ppWsSep           = ""

    -- put a few spaces between each object
    , ppSep             = "|"


    }

-- Key binding to toggle the bar (M-b)
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


myWorkspaces = ["1", "2", "3",  "4", "5", "6"]
myConfig = defaultConfig
    { modMask = mod4Mask
    ,workspaces = myWorkspaces
    ,terminal = "urxvt +sb -tr -geometry 80x24."
    ,layoutHook = spacingRaw True (Border 0 1 10 1) True (Border 5 5 5 5) True $
                avoidStruts $ layoutHook azertyConfig
    ,manageHook = manageDocks <+> manageHook azertyConfig

    }

    `additionalKeysP`
    [ ("M-c", spawn "chromium google.com"),
      ("M-f", spawn "firefox-developer-edition"),
      ("M-S-t", spawn "cool-retro-term --fullscreen"),
      ("M-S-k", spawn "keepassx ~/credentials.kdb"),
      ("M-S-d", spawn "dbeaver"),
      ("<XF86AudioLowerVolume>", spawn "amixer set Master 2%-"),
      ("<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+"),
      ("<XF86MonBrightnessUp>", spawn "xbacklight +10"),
      ("<XF86MonBrightnessDown>", spawn "xbacklight -10")]
