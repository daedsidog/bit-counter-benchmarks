: next-byte ( -- char.byte | 0 )
  begin
    source >in @ /string if c@  1 >in +! exit then
    ( c-addr ) drop refill 0= 
  until 0 ;

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
  stdin [: refill drop count-1s . cr ;] execute-parsing-file ;

main
bye