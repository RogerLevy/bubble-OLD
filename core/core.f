include engine/core/preamble         \ base dependencies, incl. Allegro, loaded once per session

global idiom [core]

include engine/core/2016             \ entitlements
include engine/core/fixext           \ fixed point extensions
include engine/core/initDisplay      \ allegro window management words
include engine/core/border
include engine/core/input            \ allegro input support words
include engine/core/piston           \ the main loop
include engine/core/allegro-floats   \ utility words for passing floats to allegro
include engine/core/gfx              \ baseline graphics helpers (bitmap, image, subimage)

