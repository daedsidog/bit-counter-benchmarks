: next-byte ( -- byte )
  stdin key-file
  dup 10 = if drop 0 exit then ; 

variable longest-bits
variable current-bits

: update-longest-bits ( -- )
  current-bits @ longest-bits @ >
  if
    current-bits @ longest-bits !
  then ;

: bit-on? ( byte idx -- flag )
  swap >r >r
  1 7 r> - lshift r> and 0 <> ;

: count-1s ( -- longest-bitcount )
  0 longest-bits ! ( )
  0 current-bits ! ( )
  begin ( )
    next-byte ( byte )
    dup 0 = if ( byte )
      update-longest-bits ( byte )
      drop
      longest-bits @ ( n )
      exit ( n ) \ This is the longest-bitcount return value. 
    then ( byte )
    8 0 ( byte 8 0 )
    ?do ( byte )
      dup i bit-on? invert ( byte flag )
      if ( byte )
        update-longest-bits ( byte )
        0 current-bits ! ( byte )
      else ( byte )
        current-bits @ 1 + current-bits ! ( byte )
      then ( byte )
    loop ( byte )
    drop ( )
  again ; ( )

: main ( -- )
  count-1s . cr ;

main
bye
