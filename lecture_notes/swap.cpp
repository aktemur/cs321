#include <iostream>

using namespace std;

void swapP(int *x, int *y) {
  int temp = *x;
  *x = *y;
  *y = temp;
}

void swapV(int x, int y) {
  int temp = x;
  x = y;
  y = temp;
}

// x and y are passed by reference, not value.
void swapR(int &x, int &y) {
  int temp = x;
  x = y;
  y = temp;
}

int main() {
  int a = 33;
  int b = 90;
  cout << "a: " << a << " b: " << b << "\n";

  cout << "Calling swapV...\n";
  swapV(a, b);
  cout << "a: " << a << " b: " << b << "\n";

  cout << "Calling swapP...\n";
  int *ap = &a;
  int *bp = &b;
  swapP(ap, bp);
  cout << "a: " << a << " b: " << b << "\n";

  cout << "Calling swapR...\n";
  swapR(a, b);
  cout << "a: " << a << " b: " << b << "\n";

  return 0;
}
