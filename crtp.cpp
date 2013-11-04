#include <iostream>


template <class Derived>
class Base
{
public:
  void eval()
  {
    static_cast<Derived *>(this)->eval();
  }
};


struct Derived: public Base<Derived>
{
public:
  void eval()
  {
    std::cout << "Derived" << std::endl;
  }
};


int main()
{
  Derived().eval();
}
