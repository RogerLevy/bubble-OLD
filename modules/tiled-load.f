create bgObjTable 1024 cells /allot \ bitmaps
staticvar firstgid

defer onLoadBox  ( pen=xy -- )
:noname [ is onLoadBox ] cr ." WARNING: onLoadBox is not defined!" ;

doming +order

staticvar 'onMapLoad
: onMapLoad:  ( class -- <code;> )  :noname swap 'onMapLoad ! ;
: onMapLoad  ( -- )  me class @ 'onMapLoad @ execute ;

: gid>class  ( n -- class )
  locals| n |
  lastClass @
  begin  dup firstgid @ 1 - n u<  over prevClass @ 0 =  or  not while
    prevClass @
  repeat  ; \ cr dup body> >name count type ;

\ Here is where I think we detect the bgobj tileset and create our table,
\ loading images as needed.
\ don't forget to free any old images first and clear the table.

: clearbgimages
    bgObjTable 1024 0 do @+ ?dup if al_destroy_bitmap then loop  drop
    bgObjTable 1024 ierase ;

: addBGImage  ( dest path c -- dest+cell )
    " data/maps/" s[ +s ]s zstring al_load_bitmap !+ ;

: bgobjtiles ( dest type -- dest )
    dom.element <> ?exit  nest  " image" ?sib drop  .node " source" @attr$ addBGImage  unnest ;

: bgobj?   " name" @attr$ " bgobj" compare 0= ;

: readTileset  ( -- )
  " firstgid" @attr ( n )  " name" @attr$ script  ( class )  firstgid !
  bgobj? -exit  clearbgimages  bgobjtable  ['] bgobjtiles drill  drop ;

\ utility word ?PROP: read custom object property

:noname  ( addr c type -- addr c flag )  \ check the name attribute of each property element til we find a match
  dom.element = -exit  2dup " name" @attr compare 0= ;

  \ only consists of elements called "property" so no need to check the names of the elements
  : ?prop  ( addr c -- false | val true )
    nest
    " properties" ?sib  not if  unnest ( addr c ) 2drop false exit  then
    [ literal ] search   nip nip if  " value" @attr  true  else  false then
    unnest  unnest ;

: *instance  ( -- )
  cr ." ...CREATING INSTANCE "
  " gid" @attr gid>class one
  ." $" me h.
  onMapLoad ;
  
: gidObject  ( -- )
  cr ." GID OBJECT!!!"  .node  *instance ;

: fixY  " height" @attr negate peny +! ;

: readObject
  " x" @attr " y" @attr  at
  " name" attr? if
    " gid" attr? if  fixY  then
    " name" @attr$ cr ." EXECUTING: " 2dup type  evaluate
  else
    " gid" attr? if  " height" @attr negate peny +! gidObject
                 else  cr ." BOX!!!!" .node onLoadBox  then
  then
;
  \ read object.
  \  collision rectangles have no gid.  some have a type, to make it slippery or dangerous.
  \  actors have a gid.

: objectGroupKids  ( type -- )
  case
    dom.attribute of
      \ read group attributes.  just the name.  identifies the layer.  can skip, for now.
    endof
    dom.element of
      " object" name? if  readObject  then
    endof
  endcase
;

: mapKids ( type -- )
  dom.element = if
    " tileset" name? if  readTileset  then
    " objectgroup" name? if  ['] objectGroupKids drill  then
  then
;

: clearGIDs  ( -- )
  firstClass @  begin  ?dup while  #-1 over firstGID ! nextClass @  repeat ;

: loadTMX  ( path count -- )
  me >r
  clearGIDs
  file@  2dup read drop free throw
  nest  " map" ?sib not abort" File is not TMX format!"
  fixed  ['] mapKids drill  done
  r> as ;


doming -order

