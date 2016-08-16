\ RAD tool (based on ideas from "Apprentice" and before that "Studio")

\ First version
\  - Functionality and expedience over efficiency
\  - 

package rading

node super
  xvar x xvar y xvar w xvar h
  xvar attr
  xvar 'show  xvar 'event
  /list xfield kids
  0 xfield data
class element


: obj  ( class -- object )
  dup sizeof allocate throw dup rot class ! ;

: destroy  ( element -- )
  dup kids length if  dup kids first @  begin ?dup while  dup next @ >r  recurse  r> repeat  then
  dup  parent @ ?dup if  >r dup r> remove  then  free throw ;

\ staticvar family

\ NEEDS TO BE INSERT
0 value this
: ,  ( class -- )
  this >r  obj to this  this r> parent @ add  at@ this x 2v! ;




end-package
