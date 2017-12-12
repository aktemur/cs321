#include <stdio.h>

int main() {
  int ia[3] = {10, 11, 12};
  char ca[3] = {'a', 'b', 'c'};
  int *pi = ia;
  char *pc = ca;

  printf("pi: %p, pc: %p, *pi: %d, *pc: %c \n", pi, pc, *pi, *pc);

  printf("sizeof(int): %lu, sizeof(char): %lu\n", sizeof(int), sizeof(char));
  pi++;
  pc++;
  printf("pi: %p, pc: %p, *pi: %d, *pc: %c \n", pi, pc, *pi, *pc);

  // LESSON: Incrementing a pointer does NOT simply increase the value
  // of the pointer by 1 byte;
  // but rather it increases the value of the pointer by one "item",
  // so that the pointer points to the next item in the memory.
  
  return 0;
}
