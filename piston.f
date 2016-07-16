
defer render        \ render frame of the game
defer sim           \ run one step of the simulation of the game
defer frame         \ the body of the loop.  can bypass RENDER and SIM if desired.

variable simerr
variable renerr

0 value me
: as  " to me" evaluate ; immediate

variable info  \ enables debugging mode display

include engine\piston-internals

: ok  clearkb >gfx +timer  begin  frame  breaking?  until  -timer >ide  false to breaking? ;
