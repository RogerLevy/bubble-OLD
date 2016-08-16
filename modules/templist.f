\ create an expandable list on the system heap
fixed

package templisting

0  xvar mem  xvar size  xvar next  struct /templist

public

: >items  mem @ ;
: #items  next @ cell/ s>p ;

: templist  ( -- <name> )
    create here &o for> /templist /allot
    16 cells allocate throw  o mem !
    16 cells o size ! ;

private : (resize)  o mem @ over resize throw o mem !  o size ! ;
public

: vacate  ( templist -- )
    &o for>  16 cells (resize)  0 o next ! ;

: ?expand  &o for>  o next @  o size @  >= -exit  o size @ 2 * (resize) ;

: push  ( value templist -- )
    dup ?expand  &o for>  o >items o next @ + !  cell o next +! ;

end-package
