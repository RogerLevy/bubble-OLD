\ Saturn default piston config

: physics  0 stage all>  vx 2v@ x 2v+! ;
: logic  0 stage all>  act ;
: cls  0.5 0.5 0.5 1.0 clear-to-color ;

:noname  [ is sim ]  physics  logic  sweep  1 +to #frames ;
:noname  [ is render ] cls  0 stage all> show ;

: game-frame  wait  ['] game-events epump  ?redraw ;
' game-frame is frame
