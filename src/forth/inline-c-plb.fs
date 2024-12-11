#include core.mfc

C #include <stdio.h>

\ This is the "Forth code" used for the inline C MinForth benchmark.

: main
C  char byte;
C  size_t longest_bits = 0;
C  size_t current_bits = 0;
C  while ((byte = getchar()) != EOF) {
C    for (int i = 0; i < 8; ++i) {
C      if (0 == ((0b10000000 >> i) & byte)) {
C        if (current_bits > longest_bits) {
C          longest_bits = current_bits;
C        }
C        current_bits = 0;
C      } else {
C        ++current_bits;
C      }
C    }
C  }
C  if (current_bits > longest_bits) {
C    longest_bits = current_bits;
C  }
C  printf("%zu\n", longest_bits); ;

#reduce