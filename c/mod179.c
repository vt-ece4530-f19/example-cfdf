#include <stdio.h>

unsigned modk(unsigned x, unsigned k) { return (x & ((1 << k) - 1)); }
unsigned divk(unsigned x, unsigned k) { return (x >> k); }

unsigned modulo(unsigned x) {
  unsigned r, q, k, a, m, z;
  m = 0xB3; // 179
  k = 8;
  a = (1 << k) - m;
  r = modk(x, k);
  q = divk(x, k);
  do {
    do {
      r = r + modk(q * a, k);
      q = divk(q * a, k);
    } while (q != 0);
    q = divk(r, k);
    r = modk(r, k);
  } while (q != 0);
  z = (r >= m) ? r - m : r;
  return z;
}

void main() {
  unsigned v = modulo(33617);

  printf("%d %d\n", v, 33617 % 179);
}
