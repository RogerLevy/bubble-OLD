\ {nodoc}
\ Copyright 2014 - Leon Konings - Konings Software.
\ Created for Roger Levy

\ Note:  This library is intended to be ANS94 compatible.
\  If it isn't, then we need to take the steps to fix that.

true constant qfolder

include engine\lib\qfolder\utilities
[undefined] linux?   [IF]   include engine\lib\qfolder\windows
                     [ELSE] include engine\lib\qfolder\linux
[THEN]
include engine\lib\qfolder\dirwalker
include engine\lib\qfolder\linuxpath
include engine\lib\qfolder\main
