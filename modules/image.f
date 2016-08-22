\ ---------------------------------- images -----------------------------------
fixed
0
  xvar bmp  xvar subw  xvar subh  xvar fsubw  xvar fsubh
  xvar subcols  xvar subrows  xvar numSubimages
struct /image

: initImage  ( ALLEGRO_BITMAP image -- ) bmp ! ;

: image  ( -- <name> <path> )
  create /image allotment <zfilespec> al_load_bitmap swap initImage ;

\ dimensions
: imageW  bmp @ bitmapW ;
: imageH  bmp @ bitmapH ;
: imageDims  dup imageW swap imageH ;

\ ------------------------------ subimage stuff -------------------------------
fixed
: subdivide  ( tilew tileh image -- )
  >r  2dup r@ subw 2v!  2af r@ fsubw 2v!
  r@ imageDims r@ subw 2v@ 2/ 2pfloor  2dup r@ subcols 2v!
  *  r> numSubimages ! ;

: >subxy  ( n image -- x y )                                                    \ locate a subimage by index
  >r  pfloor  r@ subcols @  /mod  2pfloor  r> subw 2v@ 2* ;

: afsubimg  ( n image -- ALLEGRO_BITMAP fx fy fw fh )                           \ helps with calling Allegro blit functions
  >r  r@ bmp @  swap r@ >subxy 2af  r> fsubw 2v@ ;
