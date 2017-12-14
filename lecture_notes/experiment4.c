#include <stdio.h>

int main() {
  int ia[3] = {10, 11, 12};
  char ca[3] = {'a', 'b', 'c'};
  double da[4] = {100.1, 100.2, 100.3, 100.4};
  int *pi = ia;
  char *pc = ca;
  double *pd = da;

  printf("pi: %p, pc: %p, pd: %p, *pi: %d, *pc: %c *pd: %f\n",
         pi, pc, pd, *pi, *pc, *pd);

  printf("sizeof(int): %lu, sizeof(char): %lu, sizeof(double): %lu\n",
         sizeof(int), sizeof(char), sizeof(double));
  pi++;
  pc++;
  pd++;
  printf("pi: %p, pc: %p, pd: %p, *pi: %d, *pc: %c *pd: %f\n",
         pi, pc, pd, *pi, *pc, *pd);

  // LESSON: Incrementing a pointer does NOT simply increase the value
  // of the pointer by 1 byte;
  // but rather it increases the value of the pointer by one "item",
  // so that the pointer points to the next item in the memory.

  return 0;
}
