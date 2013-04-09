#include <iostream>
#include <memory>
#include <vector>

// An example of the "Pointer Implementation" pattern
// Originally from GOTW by Hurb Sutter

class Container {
 public:
  Container(const size_t size);
  Container(const Container &other);
  Container &operator=(const Container &other);
  int &operator[](const int index);
  const int &operator[](const int index) const;

 private:
  class Impl;
  std::auto_ptr<Impl> _impl;
};


class Container::Impl {
public:
  Impl(const size_t size) {
    vec.resize(size);
  }
  std::vector<int> vec;
};


Container::Container(const size_t size)
  : _impl(new Impl(size))
{}

Container::Container(const Container &other)
  : _impl(new Impl(other._impl->vec.size()))
{
  _impl->vec = other._impl->vec;
}

Container &Container::operator=(const Container &other)
{
  _impl->vec = other._impl->vec;
  return *this;
}

int& Container::operator[](const int index)
{
  return _impl->vec[index];
}

const int& Container::operator[](const int index) const
{
  return _impl->vec[index];
}


int main()
{
  Container c(23);
  c[13] = 37;
  std::cout << c[13] << std::endl;
  Container copy = c;
  copy[13] = 4711;
  std::cout << c[13] << std::endl;
}
