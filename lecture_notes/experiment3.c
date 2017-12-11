#include <stdio.h>

int main() {
  int x;
  int *p;
  p = &x; // p now points to x
  x = 5;
  int y;
  y = *p + 10; // y is 15.
  printf("x: %d, y: %d, *p: %d, p: %p \n", x, y, *p, p);
  
  *p = *p + 1; // x incremented by 1; p still points to x
  printf("x: %d, y: %d, *p: %d, p: %p \n", x, y, *p, p);

  p[0] = 99; // x is 99
  p[0]++;    // x is 100
  printf("x: %d, y: %d, *p: %d, p: %p \n", x, y, *p, p);
  
  int a[3] = {70, 71, 72};
  p = a; // Same as: p = &(a[0]); p points to the first element of a.
  printf("x: %d, y: %d, a[0]: %d, *p: %d, p: %p \n", x, y, a[0], *p, p);
  
  p = p + 2; // p points to a[2]
  p[-1] = 81; // changed a[1]
  printf("a[0]: %d, a[1]: %d, a[2]: %d, *p: %d, p: %p \n", a[0], a[1], a[2], *p, p);

  *(p - 1) = 91; // changed a[1] again
  printf("a[0]: %d, a[1]: %d, a[2]: %d, *p: %d, p: %p \n", a[0], a[1], a[2], *p, p);

  p--; // p now points to a[1]
  a[0] = *p;
  printf("a[0]: %d, a[1]: %d, a[2]: %d, *p: %d, p: %p \n", a[0], a[1], a[2], *p, p);

  *(a + 2) = 55; // Arrays can be used exactly like pointers, except...
  // a++; // ...except that you CANNOT change the value of an array variable. Compiler rejects this line. 
  printf("a[0]: %d, a[1]: %d, a[2]: %d, *p: %d, p: %p \n", a[0], a[1], a[2], *p, p);
    
  return 0;
}
