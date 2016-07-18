\ better XML handling.
\ only read words for now (7/17/2016)

only forth definitions

[defined] decimal [if] decimal [then]

pushpath cd engine/lib/ffl-0.8.0
package ffling
private
  [UNDEFINED] ffl.version [IF]
    include ffl/config.fs
  [THEN]
public
  include ffl/dom.fs
end-package
poppath


package xmling
dom-create dom

\ the node in here is different from the one defined in nodes.f
: >root ( dom -- node )  dom>iter nni-root ;
: >next ( node -- node|0 )  nnn>dnn dnn-next@ ;
: done  dom dom-(free) ;
: xml  ( adr c -- root-node )  done  true dom dom-read-string 0= throw  dom >root ;
: #children  ( node -- n )  nnn>children dnl>length @ s>p ;
: @name  ( node -- adr c )  dom>node>name str-get ;
: @value  ( node -- adr c )  dom>node>value str-get ;
: @type  ( node -- dom-node-type )  dom>node>type @ ;
: >first  nnn>children dnl>first @ ;
0 value XT
: (scan)  ( node -- ) ( ... node -- stop? ... )
    dup #children 0= if drop abort" element has no children" exit then
    >first   begin  ?dup while  dup XT execute if drop exit then  >next  repeat ;
: scan  ( node xt -- ) ( ... node -- stop? ... )
    XT >r  to XT  (scan)  r> to XT  ;
: .name  ." <" @name type ." >" space ;
: (.elements)  dup @type dom.element = if  .name  else  drop  then  false ;
: .elements  ( node -- )  ['] (.elements) scan ;
: .attribute  dup @name type ." =" @value type space ;
: (.attributes)  dup @type dom.attribute = if  .attribute  else  drop  then  false ;
: .attributes  ( node -- )  ['] (.attributes) scan ;
: .element  dup .attributes .elements ;
: ?el ( node adr c n -- node true | false )
    locals| n c adr |
    dup #children 0= if drop abort" element has no children" exit then 
    >first  begin  ?dup while
        dup @type dom.element = if
            dup @name adr c compare 0=  n 0 = and if  true  exit then
            -1 +to n
        then
        >next
    repeat false ;
: el  ( node adr c n -- node )  ?el 0= abort" child element not found" ;
: (?attr)  ( node adr c -- node true | false )
    locals| c adr |
    dup #children 0= if drop abort" element has no children" exit then
    >first  begin  ?dup while
        dup @type dom.attribute = if
            dup @name adr c compare 0=  if  true  exit then
        then
        >next
    repeat false ;
: ?attr$  ( node adr c -- adr c true | false )  (?attr) >r r@ if @value then r> ;
: ?attr  ( node adr c -- node true | false )  (?attr) >r r@ if @value evaluate then r> ;
: attr ( node adr c -- n )  ?attr 0= abort" attribute not found" ;
: attr$ ( node adr c -- adr c )  ?attr$ 0= abort" attribute not found" ;

\ : text ( node -- adr c ) ;

end-package
