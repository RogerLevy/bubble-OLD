only forth definitions

pushpath cd engine\lib\ffl-0.8.0

decimal


global ffling +order
include ffl/b64.fs
ffling -order

decimal

global

: 64,  ( base64-src count -- )
  str-new >r  r@ b64-decode here over allot swap move  r> str-free ;

poppath
