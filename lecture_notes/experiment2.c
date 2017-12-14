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

void square(int x, int *res) {
  int sq = x * x;
  *res = sq;
}

void test3() {
  int n = 6;
  int r;
  square(n, &r);
  printf("r = %d\n", r);
}

void fact(int n, int *res) {
  if (n == 0) {
    *res = 1;
  } else {
    int rs;
    fact(n-1, &rs);
    *res = n * rs;
  }
}

void test4() {
  int k = 5;
  int r;
  fact(k, &r);
  printf("r = %d\n", r);
}

int main() {
  test3();

  return 0;
}
