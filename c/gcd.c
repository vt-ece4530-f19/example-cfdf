unsigned gcd(unsigned a, unsigned b) {

  while (a != b)
    if (b > a)
      b = b - a;
    else
      a = a - b;

  return a;
}
