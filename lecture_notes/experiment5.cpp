#include <iostream>

using namespace std;

class Account {
public:
  Account(int id, int balance, int customerId) {
    this->id = id;
    this->balance = balance;
    this->customerId = customerId;
  }

  int id;
  int balance;
  int customerId;
};

// CAUTION: This is inefficient!
// A whole Account object is copied.
void fooV(Account a) {
  a.balance += 50;
}

void fooR(Account &a) {
  a.balance += 50;
}

void fooP(Account *a) {
  a->balance += 50;
}

int main() {
  Account acc(1, 100, 5); // This is a stack-allocated, local object.
  Account *p = new Account(2, 500, 80); // This is heap-allocated
  cout << acc.balance << "\n";
  fooV(acc);
  cout << acc.balance << "\n";  
  fooR(acc);
  cout << acc.balance << "\n";
  fooP(&acc);
  cout << acc.balance << "\n";  
}
