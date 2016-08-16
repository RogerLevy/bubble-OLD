\ Lexicons
\  An lexicon is a snapshot of the search order + context.
\  Lexicons can be "extended" into other lexicons by letting them pick up the current search order
\  Lexicons are automatically updated when switched between.
\  You can also tell the system to revert the search order to the lexicon's stored state.
\  Maximum lexicon size is 16 wordlists.

\ format:  current , order-count , wordlists ...

0 value lexicon


: (update-lexicon)  ( lexicon -- )
  get-current !+  >r  get-order  dup r@ !  r> cell+ swap
    cells bounds swap cell- do  i !  -cell +loop ;

: update-lexicon  ( -- )
  lexicon (update-lexicon) ;

: (load-lexicon)  ( lexicon -- )
  @+ set-current  @+ dup >r  0 do  @+ swap  loop  drop  r> set-order ;

: revert-lexicon  lexicon (load-lexicon) ;

: create-lexicon  create  here  18 cells allot  (update-lexicon)
         does>  dup lexicon <> if  update-lexicon  then  (load-lexicon)
;

: .lexicon  lexicon body> >name count type ;
