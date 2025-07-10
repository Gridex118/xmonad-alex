{-# LANGUAGE QuasiQuotes #-}

import XMonad

import qualified XMonad.StackSet as StackSet
import XMonad.Layout.Gaps (gaps)
import XMonad.Layout.Spacing (spacingWithEdge)
import XMonad.Layout.SimpleFloat (simpleFloat)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Tabbed
import XMonad.Layout.Master (mastered)

import XMonad.Hooks.ManageHelpers (doCenterFloat)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar

import XMonad.Util.EZConfig (additionalKeysP, removeKeysP, additionalKeys, additionalMouseBindings)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.Submap (visualSubmap, subName)
import XMonad.Actions.GridSelect (goToSelected)

import Data.Map (fromList)
import Data.Monoid (Endo)
import Text.RE.TDFA.String (matched, (?=~), re)
import System.Exit (exitSuccess)

floatingWindowClasses :: [String]
floatingWindowClasses =
  [ "pavucontrol"
  , "Qemu-system-x86_64"
  , "feh"
  , "Gimp"
  , "matplotlib" ]

myFloatingWindowClassRules :: [Query (Endo WindowSet)]
myFloatingWindowClassRules =
  map (\wc -> className =? wc --> doCenterFloat) floatingWindowClasses

myMiscWindowRules :: [Query (Endo WindowSet)]
myMiscWindowRules =
  [ (role =? "gimp-toolbox" <||> role ~= [re|gimp-image-window-.*|]) --> (ask >>= doF . StackSet.sink)
  , className ~= [re|Awt.*|] --> doCenterFloat ]
  where role = stringProperty "WM_WINDOW_ROLE"
        (~=) query regex = query >>= \s -> return $ matched $ s ?=~ regex

myManageHook :: Query (Endo WindowSet)
myManageHook =
  composeAll (myMiscWindowRules ++ myFloatingWindowClassRules)

myTabbedTheme :: Theme
myTabbedTheme = def { decoHeight           = 1
                    , activeBorderWidth   = 0
                    , inactiveBorderWidth = 0
                    , urgentBorderWidth   = 0
                    , decoWidth           = 1
                    , activeColor         = "#FFFFFF"
                    , inactiveColor       = "#AAAAAA"
                    , urgentColor         = "#CCCCCC"
                    , activeTextColor     = "#FFFFFF"
                    , inactiveTextColor   = "#AAAAAA"
                    , urgentTextColor     = "#CCCCCC" }

myLayoutHook =
  onWorkspace "10" simpleFloat $
  onWorkspace "9" (avoidStruts Full ||| tiled) $
  onWorkspace "8" (avoidStruts Full ||| tiled) $
  avoidStruts $ spacingWithEdge 4 $ gaps myGapSpec commonLayouts
  where
    myGapSpec     = [(U, 3), (R, 3), (D, 3), (L, 3)]
    commonLayouts = tiled ||| mastered' ||| Full ||| Mirror tiled
    tiled         = Tall nmaster delta ratio
    nmaster       = 1
    ratio         = 1/2
    delta         = 3/100
    mastered'     = mastered (1/100) (1/2) (tabbed shrinkText myTabbedTheme)

myXMobarPP :: PP
myXMobarPP = def
  { ppSep             = magenta " . "
  , ppTitleSanitize   = xmobarStrip
  , ppCurrent         = white . wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
  , ppHidden          = white . wrap " " ""
  , ppHiddenNoWindows = lowWhite . wrap " " ""
  , ppOrder           = \(ws:_) -> [ws]
  , ppUrgent          = red . wrap (yellow "!") (yellow "!") }
  where
    magenta  = xmobarColor "#ff79c6" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

startupApplications :: [String]
startupApplications =
  [ "~/.cabal/bin/xmobar"
  , "picom -b"
  , "conky.sh"
  , "dunst"
  , "emacs --daemon"
  , "redshift" ]

myStartupHook :: X ()
myStartupHook = do
  mapM_ spawnOnce startupApplications

extraWorkspaces :: [(KeySym, String)]
extraWorkspaces = [ (xK_0, "10"), (xK_minus, "11"), (xK_equal, "12") ]

myWorkspaces :: [String]
myWorkspaces =  defaultWorkspaces ++ extraWorkspaces'
  where
    defaultWorkspaces = map show [ 1 .. 9 :: Int ]
    extraWorkspaces'  = map snd extraWorkspaces

keysToRemove :: [String]
keysToRemove =
  [ "M-p"
  , "M-S-q"
  , "M-S-c" ]

mouseButtons :: [((ButtonMask, Button), Window -> X())]
mouseButtons = map (\(modifier, key, action) -> ((modifier, key), const $ spawn action)) buttons
  where buttons =
          [ (0, 8, "xdotool type --clearmodifier -")
          , (0, 9, "xdotool type --clearmodifier +")
          , (shiftMask, 8, "xdotool type --clearmodifier [")
          , (shiftMask, 9, "xdotool type --clearmodifier ]")
          , (mod4Mask, 4, "~/scripts/soundctrl.sh +")
          , (mod4Mask, 5, "~/scripts/soundctrl.sh -")
          , (mod4Mask, 8, "~/scripts/toggle_eww_popup_panel.sh") ]

workspaceGoToKeys :: [((KeyMask, KeySym), X ())]
workspaceGoToKeys =
  [ ((mod4Mask, key), windows $ StackSet.greedyView ws)
    | (key, ws) <- extraWorkspaces ]

workspaceShiftToKeys :: [((KeyMask, KeySym), X ())]
workspaceShiftToKeys =
  [ ((mod4Mask .|. shiftMask, key), windows $ StackSet.shift ws)
    | (key, ws) <- extraWorkspaces ]

rofiKeyBind :: (String, X ())
rofiKeyBind = ("M-S-d", spawn "~/.config/rofi/implements/launcher.sh")

quickAccessKeyBinds :: [(String, X ())]
quickAccessKeyBinds =
  [ ("M-<Return>", spawn terminalEmulator)
  , ("M-S-<Return>", spawn browser)
  , ("M-<Print>", spawn screenshotTool)
  , ("M-S-n", spawn "nettoggle.sh")
  , ("M-S-p", spawn picomToggle) ]
  where terminalEmulator = "alacritty"
        browser          = "~/.local/bin/firefox"
        screenshotTool   = "flameshot gui"
        picomToggle      = "if [ `pgrep picom` ]; then pkill picom; else picom -b; fi"

commonAppSubmap :: X ()
commonAppSubmap = visualSubmap def $ fromList bindings
  where bindings =
          [ ((0, xK_z), subName "Zathura -- Resume" $ spawn "~/.config/rofi/implements/fzathura.py --resume")
          , ((shiftMask, xK_z), subName "Zathura" $ spawn "~/.config/rofi/implements/fzathura.py --menu")
          , ((controlMask, xK_z), subName "Zathura -- No Save" $ spawn "~/.config/rofi/implements/fzathura.py --no-save-recent --menu")
          , ((0, xK_w), subName "URxvt" $ spawn "urxvt")
          , ((0, xK_g), subName "Gimp" $ spawn "gimp")
          , ((0, xK_e), subName "Emacs" $ spawn "emacsclient --create-frame")
          , ((0, xK_v), subName "Volume" $ spawn "pavucontrol")
          , ((0, xK_p), subName "Private Window" $ spawn "~/.local/bin/firefox --private-window") ]

gamesSubmap :: X ()
gamesSubmap = visualSubmap def $ fromList bindings
    where bindings =
            [ ((0, xK_r), subName "RPCS3" $ spawn "~/scripts/game_launch_wrapper.sh ~/.local/bin/rpcs3-v0.0.33-17020-d51d5ce8_linux64.AppImage")
            , ((0, xK_c), subName "Citra" $ spawn "~/scripts/game_launch_wrapper.sh ~/.local/bin/citra-qt.AppImage") ]

submapBindings :: [(String, X ())]
submapBindings =
  [ ("M-d", commonAppSubmap)
  , ("M-a", gamesSubmap) ]

applicationBindings :: [(String, X ())]
applicationBindings = [rofiKeyBind] ++ quickAccessKeyBinds ++ submapBindings

windowManagerBindings :: [(String, X ())]
windowManagerBindings =
  [ ("M-q", kill)
  , ("M-g", goToSelected def)
  , ("M-m", windows StackSet.swapMaster)
  , ("M-S-<Escape>", io exitSuccess) ]

main :: IO ()
main = xmonad
       . ewmh
       . docks
       . withEasySB (statusBarProp "xmobar" (pure myXMobarPP)) defToggleStrutsKey
       $ addKeybindings myXConfig
  where
    addKeybindings xconfig =
      xconfig
      `removeKeysP` keysToRemove
      `additionalMouseBindings` mouseButtons
      `additionalKeys` workspaceGoToKeys ++ workspaceShiftToKeys
      `additionalKeysP` applicationBindings ++ windowManagerBindings
    myXConfig =
      def { modMask     = mod4Mask
          , workspaces  = myWorkspaces
          , layoutHook  = myLayoutHook
          , manageHook  = myManageHook <+> manageHook def
          , startupHook = myStartupHook
          , terminal    = "alacritty"
          , borderWidth = 0 }
