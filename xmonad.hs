import Data.Monoid (All)
import System.Exit (exitSuccess)
import System.IO (Handle, hPutStrLn)
import XMonad
import XMonad.Actions.CycleWS (toggleWS, moveTo, WSType (..))
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves
import XMonad.Hooks.CurrentWorkspaceOnTop (currentWorkspaceOnTop)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doCenterFloat, isDialog)
import XMonad.Layout.Gaps (gaps)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.WindowNavigation (windowNavigation, Navigate (..))
import XMonad.Util.CustomKeys (customKeys)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.WorkspaceCompare (getSortByIndex)
import qualified Data.Map as M (Map, fromList, (!))
import qualified XMonad.Actions.ConstrainedResize as R (mouseResizeWindow)
import qualified XMonad.Actions.FlexibleManipulate as F
import qualified XMonad.StackSet as S

main :: IO ()
main = do
    xmobarPipe <- spawnPipe "/usr/bin/xmobar"
    xmonad . ewmh . docks
        $ def { XMonad.borderWidth        = 1
              , XMonad.workspaces         = myWorkspaces
              , XMonad.layoutHook         = myLayoutHook
              , XMonad.terminal           = "/usr/bin/urxvt"
              , XMonad.normalBorderColor  = "#2f2b2a"
              , XMonad.focusedBorderColor = "#c1ab83"
              , XMonad.modMask            = mod4Mask
              , XMonad.keys               = customKeys myOldKeys myNewKeys
              , XMonad.logHook            = myLogHook >> xmobarConfig xmobarPipe
              , XMonad.startupHook        = myStartupHook
              , XMonad.mouseBindings      = myMouseBindings
              , XMonad.manageHook         = myManageHook
              , XMonad.handleEventHook    = myHandleEventHook
              , XMonad.focusFollowsMouse  = False
              , XMonad.clickJustFocuses   = False
              }

xmobarConfig :: Handle -> X ()
xmobarConfig h = 
    dynamicLogWithPP 
        $ def { ppCurrent         = wrap ":: " " ::"
              , ppVisible         = const ""
              , ppHidden          = const ""
              , ppHiddenNoWindows = const ""
              , ppUrgent          = const ""
              , ppSep             = " :: "
              , ppWsSep           = " :: "
              , ppTitle           = const ""
              , ppTitleSanitize   = const ""
              , ppLayout          = const ""
              , ppOrder           = \(ws : _ : t : _) -> [ws, t]
              , ppOutput          = hPutStrLn h
              , ppSort            = getSortByIndex
              , ppExtras          = []
              }

myWorkspaces :: [WorkspaceId]
myWorkspaces = map show [1 .. 9 :: Int]

myLayoutHook = 
    myTallLayout ||| myFullLayout
    where
        myTallLayout = 
            limitWindows 3 .
            avoidStruts .
            spacing 8 . 
            gaps [ (U, 8)
                 , (D, 8)
                 , (R, 8)
                 , (L, 8)
                 ] .
            windowNavigation
                $ ResizableTall nmaster delta ratio []
                where
                    nmaster = 1
                    delta   = 10 / 100
                    ratio   = 1 / 2
        myFullLayout = 
            limitWindows 3 .
            noBorders
                $ Full

myOldKeys :: XConfig Layout -> [(KeyMask, KeySym)]
myOldKeys XConfig {XMonad.modMask = m} =
    [ (m .|. shiftMask, xK_1)
    , (m .|. shiftMask, xK_2)
    , (m .|. shiftMask, xK_3)
    , (m .|. shiftMask, xK_4)
    , (m .|. shiftMask, xK_5)
    , (m .|. shiftMask, xK_6)
    , (m .|. shiftMask, xK_7)
    , (m .|. shiftMask, xK_8)
    , (m .|. shiftMask, xK_9)
    , (m .|. shiftMask, xK_Return)
    , (m .|. shiftMask, xK_Tab)
    , (m .|. shiftMask, xK_c)
    , (m .|. shiftMask, xK_e)
    , (m .|. shiftMask, xK_j)
    , (m .|. shiftMask, xK_k)
    , (m .|. shiftMask, xK_p)
    , (m .|. shiftMask, xK_q)
    , (m .|. shiftMask, xK_r)
    , (m .|. shiftMask, xK_slash)
    , (m .|. shiftMask, xK_space)
    , (m .|. shiftMask, xK_w)
    , (m,               xK_1)
    , (m,               xK_2)
    , (m,               xK_3)
    , (m,               xK_4)
    , (m,               xK_5)
    , (m,               xK_6)
    , (m,               xK_7)
    , (m,               xK_8)
    , (m,               xK_9)
    , (m,               xK_Return)
    , (m,               xK_Tab)
    , (m,               xK_comma)
    , (m,               xK_e)
    , (m,               xK_h)
    , (m,               xK_j)
    , (m,               xK_k)
    , (m,               xK_l)
    , (m,               xK_m)
    , (m,               xK_n)
    , (m,               xK_p)
    , (m,               xK_period)
    , (m,               xK_q)
    , (m,               xK_question)
    , (m,               xK_r)
    , (m,               xK_space)
    , (m,               xK_t)
    , (m,               xK_w)
    ]

myNewKeys :: XConfig Layout -> [((KeyMask, KeySym), X ())]
myNewKeys conf @ XConfig {XMonad.modMask = m} =
    [ ((m .|. shiftMask, xK_q), io exitSuccess)
    ]
    ++
    [ ((m, xK_Return), spawn $ XMonad.terminal conf)
    , ((m, xK_r),      spawn "${HOME}/.bin/dmenu")
    , ((m, xK_d),      kill)
    ] 
    ++
    [ ((m, xK_c), namedScratchpadAction myScratchpads "scratchpad")
    , ((m, xK_v), namedScratchpadAction myScratchpads "volume")
    , ((m, xK_m), namedScratchpadAction myScratchpads "player")
    , ((m, xK_t), namedScratchpadAction myScratchpads "htop")
    ]
    ++
    [ ((m .|. shiftMask, xK_r), spawn "${HOME}/.bin/rxmonad")
    , ((m .|. shiftMask, xK_t), spawn "${HOME}/.bin/redshifter")
    , ((m .|. shiftMask, xK_s), spawn "${HOME}/.bin/xcast -x -d 0")
    , ((m .|. shiftMask, xK_x), spawn "/usr/bin/pkill --full 'x11grab'")
    , ((m .|. shiftMask, xK_p), spawn "${HOME}/.bin/xshot")
    ]
    ++
    [ ((0, 0x1008FF11), spawn "/usr/bin/amixer -q set 'Master' 5%- unmute")
    , ((0, 0x1008FF12), spawn "/usr/bin/amixer -q set 'Master' toggle")
    , ((0, 0x1008FF13), spawn "/usr/bin/amixer -q set 'Master' 5%+ unmute")
    , ((0, 0x1008FF14), spawn "${HOME}/.bin/pp")
    , ((0, 0x1008FF15), spawn "/usr/bin/mpc --no-status stop")
    , ((0, 0x1008FF16), spawn "/usr/bin/mpc --no-status prev")
    , ((0, 0x1008FF17), spawn "/usr/bin/mpc --no-status next")
    ]
    ++
    [ ((m, xK_k), sendMessage $ Go U)
    , ((m, xK_j), sendMessage $ Go D)
    , ((m, xK_l), sendMessage $ Go R)
    , ((m, xK_h), sendMessage $ Go L)
    ]
    ++
    [ ((m .|. shiftMask, xK_k), sendMessage $ Swap U)
    , ((m .|. shiftMask, xK_j), sendMessage $ Swap D)
    , ((m .|. shiftMask, xK_l), sendMessage $ Swap R)
    , ((m .|. shiftMask, xK_h), sendMessage $ Swap L)
    ]
    ++
    [ ((m,               xK_i), sendMessage $ IncMasterN 1)
    , ((m .|. shiftMask, xK_i), sendMessage $ IncMasterN (-1))
    ]
    ++
    [ ((m, xK_s), sendMessage MirrorShrink)
    , ((m, xK_e), sendMessage MirrorExpand)
    ]
    ++
    [ ((m, xK_p), promote) 
    ]
    ++
    [ ((m .|. shiftMask, xK_Tab), rotSlavesUp) 
    ]
    ++
    [ ((m,               xK_space), sendMessage NextLayout)
    , ((m .|. shiftMask, xK_space), withFocused $ windows . S.sink)
    ]
    ++
    [ ((m .|. controlMask, xK_l),   moveTo Next $ WSIs notSP)
    , ((m .|. controlMask, xK_h),   moveTo Prev $ WSIs notSP)
    , ((m,                 xK_Tab), toggleWS)
    ]
    ++
    [ ((m .|. me, k), windows $ f i)
        | (i, k) <- 
            zip (XMonad.workspaces conf) [xK_1 .. xK_9 :: KeySym]
        , (f, me) <- 
            [ (S.greedyView, 0)
            , (S.shift,      shiftMask)
            ]
    ]
    where
        notSP :: X (WindowSpace -> Bool)
        notSP = return $ ("NSP" /=) . S.tag

myScratchpads :: [NamedScratchpad]
myScratchpads =
    [ NS "scratchpad" 
         "/usr/bin/urxvt -title scratchpad -e ${HOME}/.bin/scratchpad"
         (title =? "scratchpad")
         (customFloating $ S.RationalRect x y w h)
    , NS "volume" 
         "/usr/bin/urxvt -title volume -e /usr/bin/alsamixer"
         (title =? "volume")
         (customFloating $ S.RationalRect x y w h)
    , NS "player" 
         "/usr/bin/urxvt -title player -e ${HOME}/.bin/mp"
         (title =? "player")
         (customFloating $ S.RationalRect x y w h)
    , NS "htop" 
         "/usr/bin/urxvt -title htop -e /usr/bin/htop"
         (title =? "htop") (customFloating $ S.RationalRect x y w h)
    ]
    where
        x = (1 - w) / 2
        y = (resolutionH - scratchpadH) / (2 * resolutionH)
        w = scratchpadW / resolutionW
        h = scratchpadH / resolutionH
        resolutionH = 1600
        resolutionW = 900
        scratchpadH = 600
        scratchpadW = 490

myLogHook :: X ()
myLogHook = currentWorkspaceOnTop

myStartupHook :: X ()
myStartupHook = do
    startupHook def
    docksStartupHook
    windows (S.view "1")

myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = m} = M.fromList
    [ ((m, button1), \w -> focus w >> F.mouseWindow F.position w)
    , ((m, button2), \w -> focus w >> R.mouseResizeWindow w True)
    , ((m, button3), \w -> focus w >> F.mouseWindow F.linear w)
    ]

myManageHook :: ManageHook
myManageHook = composeAll $
    manageHook def :
    manageDocks :
    namedScratchpadManageHook myScratchpads :
    map (--> doCenterFloat) (isDialog : byClass ++ byProp)
    where
        byClass = map (className =?)
            [ "qemu-system-x86"
            , "qemu-system-x86_64"
            ]
        byProp = map (\(prop, var) -> stringProperty prop =? var)
            [ ("WM_WINDOW_ROLE", "GtkFileChooserDialog")
            , ("WM_WINDOW_ROLE", "gimp-startup")
            , ("WM_WINDOW_ROLE", "gimp-message-dialog")
            , ("WM_WINDOW_ROLE", "gimp-toolbox-color-dialog")
            ]

myHandleEventHook :: Event -> X Data.Monoid.All
myHandleEventHook = 
    handleEventHook def <+>
    docksEventHook <+>
    fullscreenEventHook
