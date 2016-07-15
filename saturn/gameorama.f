
\ Core:
include engine/preamble
include engine/initDisplay
include engine/input
include engine/piston
include engine/allegro-floats
include engine/gfx

\ -----------------------------------------------------------------------------

fixed
64 16 + cells struct /actorslot
include engine/modules/nodes
include engine/modules/rects
include engine/modules/id-radixsort
include engine/modules/templist

\ -----------------------------------------------------------------------------
fixed

variable factor  2 factor !
320 value gfxw                                                                  \ doesn't necessarily reflect the window size.
240 value gfxh
0 value #frames

\ -----------------------------------------------------------------------------

fixed
gfxw gfxh factor @ dup 2* initDisplay                                           \ actually init the display

create native  /ALLEGRO_DISPLAY_MODE /allot
  al_get_num_display_modes #1 -  native  al_get_display_mode

\ --------------------------------- utilities ---------------------------------
: nativew   native x@ s>p ;
: nativeh   native y@ s>p ;
: displayw  display al_get_display_width s>p ;
: displayh  display al_get_display_height s>p ;


\ some meta-compilation systems management stuff
: teardown  display al_destroy_display ; \ al_uninstall_system ;
: empty   teardown only forth empty ;

\ --------------------------------- keyboard ----------------------------------
decimal
: klast  kblast swap al_key_down  ;
: kstate kbstate swap al_key_down ;
: kdelta >r  r@ kstate 1 and  r> klast 1 and  - ;
: kpressed  kdelta 1 = ;
: kreleased  kdelta -1 = ;
: alt?   <alt> kstate     <altgr> kstate   or ;
: ctrl?  <lctrl> kstate   <rctrl> kstate   or ;
: shift? <lshift> kstate  <rshift> kstate  or ;

\ ------------------------------- joysticks -----------------------------------
decimal
: jstate ( joy# button# - 0-1.0 )
  cells swap joystick[] ALLEGRO_JOYSTICK_STATE-buttons + @  PGRAN 32767 */ ;

\ ---------------------------------- audio ------------------------------------

al_install_audio not [if] " Allegro: Couldn't initialize audio." alert -1 abort [then]
al_init_acodec_addon not [if] " Allegro: Couldn't initialize audio codec addon." alert -1 abort [then]
16 al_reserve_samples not [if] " Allegro: Error reserving samples." alert -1 abort [then]
al_restore_default_mixer  al_get_default_mixer value mixer

: sfx  ( -- <name> <path> )
  create  <zfilespec> al_load_sample ,
  does> @ 1 0 1 3af ALLEGRO_PLAYMODE_ONCE 0 al_play_sample ;

\ ----------------------------- actors / stage --------------------------------
list stage
list backstage
\ : var  create dup , cell +  does> @ me + ;                                      ( total -- <name> total+cell )
: field  create over , + immediate does> @ " me ?lit + " evaluate ;             ( total -- <name> total+cell )
         \ faster but less debuggable version
: var  cell field ;

node super
  var vis  var x  var y    var vx  var vy
  var zdepth   \ not to be confused with z position - it's for drawing order.
  var 'act  var 'show  \ <-- internal
  var flags
  staticvar 'onStart  \ kick off script
  staticvar 'onInit   \ initialize any default vars that onStart expects.
                      \ We need this because loading from a map file
                      \ can override some default values.
class actor

#1
  bit persistent#
  bit restart#
  bit unload#
value actorBit

defer oneInit  ' noop is oneInit


: set?  flags @ and ;
: unset?  flags @ and 0= ;

: start  restart# flags not!  me class @ 'onStart @ execute ;
: show>  r> code> 'show !  vis on ;                                             ( -- <code> )
: act>   r> code> 'act ! ;                                                      ( -- <code> )
: act   restart# set? if  start  then  'act @ execute ;
: show  'show @ execute ;
: itterateActors  ( xt list -- )  ( ... -- ... )
  me >r
  first @  begin  dup while  dup next @ >r  over >r  as execute  r> r> repeat
  2drop
  r> as ;
: all>  ( n list -- )  ( n -- n )  r> code>  swap itterateActors  drop ;
: (recycle)  dup >r backstage popnode dup r> sizeof erase ;
: init  restart# flags or!  me class @ 'onInit @ execute ;
: one                                                                           ( class -- me=obj )
  backstage length @ if  (recycle)  else  here /actorslot /allot  then
  dup stage add
  as
  at@ x 2v! 
  me class !  oneInit  init ;
: become  ( class -- )  me class !  init ;

: 's
  state @ if
    " me >r  as " evaluate  bl parse evaluate  " r> as" evaluate
  else
    " me swap as " evaluate  bl parse evaluate  " swap as" evaluate
  then
  ; immediate

: abandon  me dup parent @ remove ;
: sweep    0 stage all>  unload# set? -exit
           unload# flags not!
           abandon
           persistent# unset? if  me backstage add  then ;
: unload  unload# swap 's flags or! ;

\ clear everything from stage except persistent stuff.
: cleanup  backstage stage graft  0 backstage all>  persistent# set? -exit  me stage add ;  \ put persistent actors back onstage

\ clear everything from stage including persistent stuff.  persistent stuff is not sent to BACKSTAGE.
: clear  backstage stage graft  0 backstage all>  persistent# set? -exit  abandon ;  \ orphan persistent actors

: #actors  stage length @ ;

: script  ( adr c -- class )  \ load actor script if not loaded
  2dup forth-wordlist search-wordlist if  nip nip execute  else
  2dup " obj/" s[ +s " .f" +s ]s included  evaluate  then ;


include engine/saturn/configs/default.f
