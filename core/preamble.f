
\ These components will be compiled into the EXE.
\ It looks like a lot but really we're just conditionally loading a few files,
\ since this file can be loaded multiple times in a programming session.

\ Forth Language-level Extensions

  [undefined] o [if]
    0 value o
    &of o constant &o
    : for>  ( val addr -- )  r>  -rot  dup dup >r @ >r  !  call  r> r> ! ;

    : reverse   ( ... count -- ... ) 1+ 1 max 1 ?do i 1- roll loop ;

  [then]

  [undefined] idiom [if]
    include engine\lib\idiom
    : include  sp@ >r  include  r> sp@ cell+ <> ?dup if  .s abort" STACK DEPTH CHANGED" then ;
  [then]
  
  \ a directory scanner / file finder
  [undefined] qfolder [if]
    \ uncomment for linux:
    \ true constant linux?
    include engine\lib\qfolder\qfolder
  [then]

  \ ffl DOM
  [UNDEFINED] ffl.version [IF]
  include engine\lib\ffl-0.8.0\ffl
  include engine\lib\ffl-0.8.0\xml2
  include engine\lib\ffl-0.8.0\base64
  global
  poppath
  [THEN]

  \ floating point
  [undefined] f+ [if]
    +opt
    warning on
    requires fpmath
    cr .( loaded: fpmath)
  [then]
  
  \ Various extensions
  [undefined] 1sf [if]
    include engine\lib\fpext
    cr .( loaded: fpext)
  [then]
  [undefined] rnd [if]
    requires rnd
  [then]
  [undefined] zstring [if]
    include engine\lib\string-operations
  [then]
  [undefined] file@ [if]
    include engine\lib\files
  [then]
  [undefined] fixedp [if]
    true constant fixedp
    include engine\lib\fixedp_2
  [then]
  :noname [ is onSetIdiom ]  ints @ ?fixed ;

  [undefined] ALLEGRO_VERSION_INT [if]
    include engine\lib\allegro-5.2\allegro-5.2.f
  [then]

  \ RLD
  [undefined] rld [if]
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

    gild
  [then]

/RND


