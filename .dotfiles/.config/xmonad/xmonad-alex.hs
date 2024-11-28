import XMonad
import XMonad.StackSet (swapMaster)
import System.Exit

import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.SimpleFloat
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.Master

import XMonad.Hooks.ManageHelpers (doCenterFloat)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar

import XMonad.Util.EZConfig (additionalKeysP, removeKeysP, additionalKeys)
import XMonad.Util.SpawnOnce

import XMonad.Actions.Submap (visualSubmap, subName)

import Data.Map (fromList)
import XMonad.Actions.GridSelect (goToSelected)


myManageHook = composeAll
    [ className =? "pavucontrol" --> doCenterFloat
    , className =? "qemu" --> doCenterFloat
    , className =? "feh" --> doCenterFloat
    -- For Jubin's 8085simulator
    , stringProperty "WM_NAME" =? "Save Mnemonics" --> doCenterFloat
    , stringProperty "WM_NAME" =? "Warning ! " --> doCenterFloat
    --
    , stringProperty "WM_NAME" =? "Quit GIMP" --> doCenterFloat
    ]

-- This is more or less a hack
-- Couldn't remove the text, so had the fg color match the bg
myTabConfig = def { decoHeight = 1 
                  , activeBorderWidth = 0
                  , inactiveBorderWidth = 0
                  , urgentBorderWidth = 0
                  , decoWidth = 1
                  , activeColor = "#FFFFFF"
                  , inactiveColor = "#AAAAAA"
                  , urgentColor = "#AAAAAA"
                  , activeTextColor = "#FFFFFF"
                  , inactiveTextColor = "#AAAAAA"
                  , urgentTextColor = "#FFFFFF"}

myLayoutHook =
    onWorkspace "9" simpleFloat $
    onWorkspace "8" (avoidStruts Full ||| tiled) $
    onWorkspace "7" (avoidStruts Full ||| tiled) $
    avoidStruts $ spacingWithEdge 4 $ gaps [(U, 5), (R, 3), (D, 3), (L, 3)] $
            tiled
        ||| mastered (1/100) (1/2) (tabbed shrinkText myTabConfig)
        ||| Full
        ||| Mirror tiled
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = 1/2
        delta = 3/100

-- XMobar workspaces; copied from the wiki, works fine, so will not bother modifying further
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = white . wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppOrder           = \(ws:_) -> [ws]
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    }
    where
        blue, lowWhite, magenta, red, white, yellow :: String -> String
        magenta  = xmobarColor "#ff79c6" ""
        blue     = xmobarColor "#bd93f9" ""
        white    = xmobarColor "#f8f8f2" ""
        yellow   = xmobarColor "#f1fa8c" ""
        red      = xmobarColor "#ff5555" ""
        lowWhite = xmobarColor "#bbbbbb" ""

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "xmobar"
    spawnOnce "redshift"
    spawnOnce "picom -b"
    spawnOnce "conky"
    spawnOnce "/usr/lib/notification-daemon-1.0/notification-daemon"

main :: IO ()
main = xmonad
    . ewmh
    . docks
    . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
    $ def
        { modMask = mod4Mask
        , layoutHook = myLayoutHook
        , manageHook = myManageHook <+> manageHook def
        , startupHook = myStartupHook
        , terminal = "alacritty"
        , borderWidth = 0
        }
        `removeKeysP`
        [ "M-p"
        , "M-S-q"
        , "M-S-c"
        ]
        `additionalKeys`
        [ ((shiftMask, xK_Shift_R), spawn "notify-send 'hello'")    -- Okay, this is stupid; keeping it for shits and giggles
        ]
        `additionalKeysP`
        [ ("M-S-d", spawn "~/.config/rofi/implements/launcher.sh")
        -- The Application submap
        , ("M-d", visualSubmap def $ fromList
                [ ((0, xK_z), subName "Zathura" $ spawn "~/.config/rofi/implements/fzathura.sh")
                , ((shiftMask, xK_z), subName "Zathura -- selector" $ spawn "~/.config/rofi/implements/fzathura.sh --menu")
                , ((0, xK_w), subName "Wezterm" $ spawn "wezterm")
                , ((0, xK_g), subName "Gimp" $ spawn "gimp")
                , ((0, xK_e), subName "Emacs" $ spawn "emacs")
                , ((0, xK_v), subName "Volume" $ spawn "pavucontrol")
                , ((0, xK_p), subName "Private Window" $ spawn "firefox --private-window")
                ])
        -- The Games submap
        , ("M-a", visualSubmap def $ fromList
                [ ((0, xK_r), subName "RPCS3" $ spawn "~/.local/bin/rpcs3-v0.0.33-17020-d51d5ce8_linux64.AppImage")
                , ((0, xK_d), subName "Dolphin" $ spawn "dolphin-emu")
                ]
        )
        , ("M-q", kill)
        , ("M-S-r", spawn "xmonad --recompile&& xmonad --restart")
        , ("M-S-n", spawn "iwctl station wlan0 scan on")
        , ("M-<Return>", spawn "alacritty")
        , ("M-S-<Return>", spawn "firefox")
        , ("M-C-<Print>", spawn "flameshot full")
        , ("M-<Print>", spawn "flameshot gui")
        , ("M-S-p", spawn "if [ `pgrep picom` ]; then pkill picom; else picom -b; fi")
        , ("M-g", goToSelected def)
        , ("M-m", windows swapMaster)
        , ("M-S-<Escape>", io exitSuccess)
        ]
