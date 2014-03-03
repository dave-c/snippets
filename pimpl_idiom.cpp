// Pimpl idiom, based on:
// http://stackoverflow.com/questions/60570/why-should-the-pimpl-idiom-be-used

#include <memory>
class Function
{
private:
  class Derivative;

public:
  Function();
  Derivative const & derivative() const;

private:
  std::auto_ptr<Derivative> _drv;
};


class Function::Derivative
{
public:
  void tangent() const;
  void adjoint() const;
};

Function::Function()
{
  _drv = std::auto_ptr<Derivative>(new Derivative);
}

Function::Derivative const & Function::derivative() const
{
  return *_drv;
}

void Function::Derivative::tangent() const
{
  // evaluate tangent derivative
}

void Function::Derivative::adjoint() const
{
  // evaluate adjoint derivative
}


int main()
{
  Function().derivative().tangent();
  Function().derivative().adjoint();
}
