#include <stdio.h>

int main() {
  char byte;
  size_t longest_bits = 0;
  size_t current_bits = 0;
  while ((byte = getchar()) != EOF) {
    for (int i = 0; i < 8; ++i) {
      if (0 == ((0b10000000 >> i) & byte)) {
        if (current_bits > longest_bits) {
          longest_bits = current_bits;
        }
        current_bits = 0;
      } else {
        ++current_bits;
      }
    }
  }
  if (current_bits > longest_bits) {
    longest_bits = current_bits;
  }
  printf("%zu\n", longest_bits);
  return 0;
}
