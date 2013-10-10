#include <string>
#include <iostream>


class Container
{
public:
  // typedef short T;
  typedef std::string T;

  Container(T const &var) : _var(var) {}
  T get() const { return _var; }
  T const &_var;
};


int main()
{
  // Container ctr(Container::T(10));
  Container ctr(Container::T("10"));
  std::cout << ctr.get() << std::endl;
}
