\ simplified directory walker

package fdrilling
    : >filename  .filename zcount ;

    0 value xt
    : (fdrill)  ( handle param -- stop? )
        drop xt execute false ;

public
: fdrill  ( path c xt -- )  ( file-handle -- )
    xt >r  to xt
    ['] (fdrill) 0 directorieswalker1
    r> to xt ;
end-package
