
\ These components will be compiled into the EXE.

[defined] preamble [if] \\ [then]

\ Forth Language-level Extensions

  0 value o
  &of o constant &o
  : for>  ( val addr -- )  r>  -rot  dup dup >r @ >r  !  call  r> r> ! ;
  
  \ a directory scanner / file finder
  \ uncomment for linux:
  \ true constant linux?
  include engine\lib\qfolder\qfolder

  \ floating point
  +opt
  warning on
  requires fpmath
  cr .( loaded: fpmath)

  \ idioms
  include engine\lib\idioms

  \ ffl DOM

  pushpath cd engine/lib/ffl
  wordlist constant ffling   ffling +order  definitions
    include ffl/config.fs
  decimal
  global  ffling +order
    include ffl/dom.fs
    include xml2
    include base64
  ffling -order
  poppath

  \ Various extensions
  include engine\lib\fpext
  cr .( loaded: fpext)

  requires rnd

  include engine\lib\string-operations

  include engine\lib\files

  include engine\lib\fixedp_2

  include engine\lib\allegro-5.2\allegro-5.2.f

  \ RLD
  : rld  ( -- )  warning off  s" dev.f" included ;
  \ Dev tool: reload from the top

  create null-personality
    4 cells , 19 , 0 , 0 ,
    ' noop , \ INVOKE    ( -- )
    ' noop , \ REVOKE    ( -- )
    ' noop , \ /INPUT    ( -- )
    ' drop ,  \ EMIT      ( char -- )
    ' 2drop , \ TYPE      ( addr len -- )
    ' 2drop , \ ?TYPE     ( addr len -- )
    ' noop , \ CR        ( -- )
    ' noop , \ PAGE      ( -- )
    ' drop , \ ATTRIBUTE ( n -- )
    ' dup , \ KEY       ( -- char )
    ' dup , \ KEY?      ( -- flag )
    ' dup , \ EKEY      ( -- echar )
    ' dup , \ EKEY?     ( -- flag )
    ' dup , \ AKEY      ( -- char )
    ' 2drop , \ PUSHTEXT  ( addr len -- )
    ' 2drop ,  \ AT-XY     ( x y -- )
    ' 2dup , \ GET-XY    ( -- x y )
    ' 2dup , \ GET-SIZE  ( -- x y )
    ' drop , \ ACCEPT    ( addr u1 -- u2)

  : game-starter  null-personality open-personality " include main ok bye" evaluate ;
  \ Turnkey starter

  : refresh  " eventq al_flush_event_queue  rld  ok" evaluate ;



true constant preamble
gild
