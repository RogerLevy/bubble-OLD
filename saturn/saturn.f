include engine/core/core

[core] idiom [saturn]

\ engine base
include engine/saturn/gameorama

\ graphics services
include engine/modules/swes/sprites

\ load other modules
include engine/modules/stride2d
include engine/modules/collision-grid
include engine/modules/gameutils
include engine/modules/wallpaper
include engine/modules/tiled-load

\ load engine specific stuff
include engine/saturn/scripting.f

\ constants
: extents  0 0 4096 4096 ;
actor single cam
actor single player

\ variables
0 value you  \ for collisions
#1 value cbit  \ collision flag counter
variable 'dialog  \ for now this is just a flag.

\ load global data
include engine/saturn/autodata
auto-load data

\ more engine specific stuff
include engine/saturn/objects.f
include engine/saturn/physics.f
include engine/saturn/box.f
include engine/saturn/load.f
include engine/saturn/zones.f

fixed


:noname [ is oneInit ]
  at@  startx 2v!
  1 1 1 1 !color
  csolid# cmask !
  32768 zdepth !
  ;


: ?pointcull
  x 2v@ 2dup  cam 's x 2v@ 80 80 2-  gfxw gfxh 160 160 2+  2over 2+
  overlap? ?exit  me unload ;

: cull  0 stage all>  me class @ 'cull @ execute ;

\ --------------------------- camera/rendering --------------------------------

transform baseline

: /baseline  ( -- )
  baseline  al_identity_transform
  baseline  factor @ dup 2af  al_scale_transform
  baseline  al_use_transform  ;


\ camera stuff

create m  16 cells /allot

: camTransform  ( -- matrix )
  m al_identity_transform
  m  cam 's x 2v@ 2pfloor 2negate 2af  al_translate_transform
  m ;

: track ( -- )
  player 's x 2v@  player 's w 2v@ 2halve  2+
  gfxw gfxh 2halve  2-  extents 2clamp  cam 's x 2v! ;

: camview
  camTransform  dup  factor @ dup 2af  al_scale_transform
  al_use_transform ;


\ depth sorting

: enqueue  me , ;
: showem  ( addr -- addr )  here over ?do  i @ as  show  cell +loop ;
: @zdepth  [ zdepth me - ]# + @ ;
: sort  dup here over - cell/ s>p  ['] @zdepth irsort ;
: vfilter  0 stage all>  vis @ -exit  enqueue ;
: sorted  here  vfilter  sort  showem  reclaim ;


\ rendering

: para  ;
: batch  al_hold_bitmap_drawing ;
: cls  0 0 0 1 clear-to-color ;
: overlays  ;
: all  0 stage all>  show ;
: boxes  info @ -exit  0 stage all>  showCbox ;
: camRender
  cls  /baseline
  para  track  camview
  1 batch  sorted  overlays  0 batch
  boxes ;


\ bring the logic together

: ?reload  <f7> kpressed -exit  -timer reload +timer ;
: logic  0 stage all> act ;
: saturnSim  physics  zones  ?reload  logic  multi  cull  sweep  1 +to #frames ;


\ piston config

' camRender is render
' saturnSim is sim


