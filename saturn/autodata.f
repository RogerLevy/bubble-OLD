: *image  ( poth count -- )
    " image " s[ 2dup -ext -path +s " .image " +s +s ]s 2dup type cr evaluate ;

: *sound  ( path count -- )
    " sfx *" s[ 2dup -ext -path +s " * " +s +s ]s 2dup type cr evaluate ;

: (image)  >filename *image ;
: (sound)  >filename *sound ;

: autodata ( -- )
    pushpath " cd data" evaluate
    " images" ['] (image) fdrill
    " sounds" ['] (sound) fdrill
    poppath ;

autodata
