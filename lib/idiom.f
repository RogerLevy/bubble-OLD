\ better package system

\ idioms have:
\  a parent idiom
\  accessory idioms
\  a private wordlist
\  a public wordlist

\ important words:
\   `idiom` <name>
\     creates a new idiom.  has different behavior depending on
\     if currently importing the current file.  if not importing, it creates a
\     new idiom, extending the current one (whatever it might be) so that that
\     idiom is included in the new one's search order, except for its private
\     words.  if importing, and the idiom is not already defined, it creates
\     a new idiom without extending the current one.  `import` adds it as
\     an accessory before restoring the current idiom.  if importing and the
\     idiom is already defined, compilation of the rest of the current file
\     being interpreted is cancelled.
\     the default "current" wordlist for defining words is the idiom's public
\     one.
\  `include` is extended to save and restore `idiom`, the current idiom.
\  `import` saves and restores `idiom` as well as a flag that `create-idiom`
\     uses to change its behavior.
\  `.idiom` prints info about the current idiom.  usually, idioms set the
\     search order themselves when executed.
\  `set-idiom` takes an idiom and sets the search order (it replaces it.)
\     the default "current" wordlist for defining words is the idiom's public
\     one.
\  `breadth` the variable that stores the maximum # of accesory idioms the next
\     idiom can have.  it is reset to 10 every time an idiom is created.
\  `public` - set current wordlist for defining to current idiom's "publics"
\  `private` - set current wordlist for defining to current idiom's "privates"

variable 'idiom
variable breadth  8 breadth !
variable importing

\ wordlist
\ create forth-idiom
\   0 , forth-wordlist , ( wordlist ) , 0 ,

: /idiom  5 cells breadth @ cells + ;
: @parent  'idiom @ @ ;
: @publics 'idiom @ cell+ @ ;
: >publics  ?dup if  cell+ @  ?dup ?exit  then  forth-wordlist ;
: @privates 'idiom @ cell+ cell+ @ ;
: others>  'idiom @ cell+ cell+ cell+ ;  \ count , idiom , idiom ....


: .name  body> >name count type space ;
: ?none  dup ?exit  ." NONE" ;
: .idiom
  cr
  'idiom @ 0= if  ." NO CURRENT IDIOM."  exit  then
  space ." IDIOM: " 'idiom @ .name
  \ space ." PARENT: " @parent ?dup if  .name  else  ." NONE " then
  space ." IMPORTS: "
  others> @+ ?none  0 ?do  @+ .name  loop
  drop
  @parent -exit
  'idiom @ >r
  @parent 'idiom ! recurse
  r> 'idiom ! ;

: _private  @privates set-current ;
: _public   @publics  set-current ;

: add-idiom  ( idiom idiom-target -- )
  'idiom @ >r   'idiom !
  others> @+ cells + !  1 others> +!
  r> 'idiom ! ;

: wordlists+  ( ...wordlists... count idiom -- ...wordlists... count )
  'idiom @ >r  'idiom !
  @parent ?dup if  recurse  then  \ add parents' stuff first!
  others> @+ ?dup if  cells bounds swap cell- do  i @ >publics  swap 1 +  -cell +loop
                  else  drop  then 
  @publics swap 1 +
  r> 'idiom ! ;


: get-idiom  'idiom @ ;

: global  only forth definitions  'idiom off ;

: set-idiom  ?dup 0= if global exit then  'idiom !  forth-wordlist  1  'idiom @ wordlists+  @privates -rot  1 +   set-order ;

: extend-idiom  'idiom @ swap ! ;

: (idiom)
  here  /idiom /allot  8 breadth !
  ( idiom )  dup extend-idiom  'idiom !
  wordlist 'idiom @ cell+ !
  wordlist 'idiom @ cell+ cell+ !
  'idiom @ set-idiom  _public ;

: idiom
  >in @  defined  if   nip  >body  importing @ if  'idiom ! \\ exit
                                               else  set-idiom  _public  exit  then
                  else  drop  >in !  then
  create  (idiom)  does>  set-idiom  _public ;

: import   get-current >r  get-idiom >r  importing @ >r  importing on  ['] include catch  r> importing !  throw  'idiom @ r@ add-idiom  r> set-idiom  r> set-current ;
: include  get-current >r  get-idiom >r  include  r> set-idiom  r> set-current ;


\ create an exposed wordlist out of @publics or @privates in the parent's public wordlist.
\ useful for creating wordlists that can be cherrypicked onto the search order in special cases.
: export-wordlist  ( wordlist -- <name> )
  get-current >r  @parent >publics set-current  constant
  r> set-current ;

marker discard
  idiom i1
  i1
  import test/bear
  import test/fox
  .idiom
  idiom i2
  i2
  .idiom
discard

global
