#include <stdio.h>

void test1() {
  int a[5] = {80,81,82,83,84};
  int *pa;

  printf("a = %d, %d, %d, %d, %d \n", a[0], a[1], a[2], a[3], a[4]);

  pa = a; // &a[0]

  pa[2] = 72; // *(pa + 2) = 72;
  3[pa] = 73; // *(3 + pa) = 73;

  printf("a = %d, %d, %d, %d, %d \n", a[0], a[1], a[2], a[3], a[4]);
}

void test2() {
  int a = 5;
  int *p;
  int k = 60;
  p = &k;

  printf("sizeof(int) = %lu, sizeof(int*) = %lu \n", sizeof(int), sizeof(int*));
  printf("p = %p, k = %d \n", p, k);
  printf("&a = %p, &p = %p, &k = %p \n", &a, &p, &k);
}

void square(int x, int *r) {
  int sq = x * x;
  *r = sq;
}

void test3() {
  int n = 6;
  int r;
  square(n, &r);
  printf("r = %d\n", r);
}

void fact(int n, int *r) {
  if (n == 0) {
    *r = 1;
  } else {
    int rs;
    fact(n-1, &rs);
    *r = n * rs;
  }
}

void test4() {
  int k = 5;
  int r;
  fact(5, &r);
  printf("r = %d\n", r);
}

int main() {
  test2();

  return 0;
}
