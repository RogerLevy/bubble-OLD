\ some graphics helpers

0 value #frames  \ frame counter, for cheap animation

\ --------------------------- graphics services -------------------------------
\ NTS: the pen should always function as a final translation stage
\ NTS: add matrix words (as of 2/21 i'm going to keep things very basic.)
: clear-to-color  ( r g b a -- ) 4af al_clear_to_color ;
: bitmapW   al_get_bitmap_width  s>p ;
: bitmapH   al_get_bitmap_height  s>p ;
: soft-bitmaps  ( -- )
  al_get_new_bitmap_flags
  [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or ] literal or
  al_set_new_bitmap_flags ;
: crisp-bitmaps  ( -- )
  al_get_new_bitmap_flags
  [ ALLEGRO_MIN_LINEAR ALLEGRO_MAG_LINEAR or invert ] literal and
  al_set_new_bitmap_flags ;
16 cells struct /transform
: transform  create  here  /transform allot  al_identity_transform ;
decimal
: hold[ 1 al_hold_bitmap_drawing ;
: ]hold 0 al_hold_bitmap_drawing ;
decimal
0 constant FLIP_NONE
1 constant FLIP_H
2 constant FLIP_V
3 constant FLIP_HV

