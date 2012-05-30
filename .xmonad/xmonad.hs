import Data.List ( isInfixOf, isPrefixOf )
import System.IO
import System.Posix.Unistd
import XMonad
import XMonad.Actions.UpdatePointer
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Prompt
import XMonad.Prompt.Window
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run (spawnPipe)

main = do
  xmproc <- spawnPipe myBar
  xmonad $ withUrgencyHook NoUrgencyHook $ myConf {
    logHook              = myLogHook xmproc >> updatePointer (Relative 0.5 0.5)
    , manageHook         = manageHook myConf <+> myManageHook 
    , modMask            = myModMask
    , startupHook        = myStartupHook
    , terminal           = myTerminal
    , handleEventHook    = fullscreenEventHook
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#000000"
  } `additionalKeys` myKeys `additionalKeysP` myKeysP

myBar = "xmobar"

myConf = gnomeConfig {
  layoutHook  = myLayoutHook
  , workspaces = myWorkspaces
}

myKeys =
  [
    -- workspaces are distinct by screen
    ((m .|. myModMask, k), windows $ onCurrentScreen f i)
  | (i, k) <- zip (workspaces' myConf) [xK_1 .. xK_9]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
  ++
  [
    -- swap screen order
    ((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]
  ++
  [
    ((myModMask, xK_KP_Insert),    spawn "chromium") 
  , ((myModMask, xK_KP_End),       spawn "start-sts")
  , ((myModMask, xK_KP_Down),      spawn "vmware")
  , ((myModMask, xK_KP_Page_Down), spawn "emacs")
  , ((myModMask, xK_KP_Left),      spawn "xchat")
  , ((myModMask, xK_KP_Begin),     spawn "empathy") 
  , ((myModMask, xK_KP_Right),     spawn "firefox")
  , ((myModMask, xK_KP_Home),      spawn "eclipse")
    -- xK_KP_Up
    -- xK_KP_Page_Up
    -- xK_KP_Insert
  ]

myKeysP =
  [
   -- meta p spawns dmenu
  ("M-p", spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

   -- go to window prompt
  , ("M-S-g", windowPromptGoto defaultXPConfig { autoComplete = Just 500000 })

   -- lock screen
  , ("C-M1-l", spawn "exe=`xscreensaver-command -lock` && eval \"exec $exe\"")
  ]

myLayoutHook = smartBorders (layoutHook gnomeConfig)

myLogHook xmproc = dynamicLogWithPP $ xmobarPP {
  ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"
  , ppHidden = xmobarColor "#C98F0A" ""
  , ppHiddenNoWindows = xmobarColor "#C9A34E" ""
  , ppUrgent = xmobarColor "#FFFFAF" "blue" . wrap "[" "]"
  , ppLayout = xmobarColor "#C9A34E" ""
  , ppTitle =  xmobarColor "#C9A34E" "" . shorten 80
  , ppSep = xmobarColor "#429942" "" " | "
  , ppOutput = hPutStrLn xmproc
}

myManageHook = composeAll
  [ 
   -- Empathy transient windows
    title =? "Contact List"                --> doCenterFloat 
  , title =? "Messaging and VoIP Accounts" --> doCenterFloat

   -- Firefox download window  
  , className =? "Firefox" <&&> fmap (isInfixOf "Downloads") title --> doCenterFloat

   -- Spring Source
  , className =? "SpringSource Tool Suite"    <&&> 
    fmap (isPrefixOf "Spring - ") title             --> doShift "0_2"
  , title =? "SpringSource Tool Suite"              --> doShift "0_2" <+> doIgnore
  , title =? "STS"                                  --> doShift "0_2" <+> doIgnore  
--  , className =? "SpringSource Tool Suite"    <&&> 
--    title =? "PasswordRequired"                     --> doShift "0_2" <+> doFloat   
  , className =? "SpringSource Tool Suite"    <&&> 
    (not . ("   " `isPrefixOf`)) `fmap` title <&&>
    (not . ("Spring - " `isPrefixOf`)) `fmap` title --> doShift "0_2" <+> doCenterFloat
  , className =? "SpringSource Tool Suite"    <&&> 
    ("   " `isPrefixOf`) `fmap` title               --> doShift "1_2" <+> doSink

  -- Eclipse
  , className =? "Eclipse" --> doShift "0_4" 

  -- Standard window/application placements
  , appName =? "chromium"      --> doShift "0_1"
  , appName =? "vmware"        --> doShift "1_3"
  , appName =? "xchat"         --> doShift "1_1"
  , appName =? "thunderbird"   --> doShift "1_4"
  ]
  where
    doSink::ManageHook
    doSink = ask >>= \w -> liftX (reveal w) >> doF (W.sink w)

myModMask = mod4Mask

myStartupHook = setWMName "LG3D"

myTerminal = "urxvt" 

myWorkspaces = withScreens 2 ["1", "2", "3", "4", "5", "6", "7", "8", "9"] 

--

data Host = Desktop | Laptop
  deriving (Eq, Read, Show)
           
getHost :: IO Host
getHost = do
  hostName <- nodeName `fmap` getSystemID
  return $ case hostName of
    "sallen-dev" -> Desktop
    _            -> Laptop
