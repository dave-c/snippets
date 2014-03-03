// Extend a class to implement its tangent and
// adjoint derivatives using the Pimpl idiom,
// interfaces and the RAII idiom.

#include <memory>


class DerivativeBase
{
public:
  virtual ~DerivativeBase() {}
  virtual void evaluateTangent() const = 0;
  virtual void evaluateAdjoint() const = 0;
};


class Differentiable
{
public:
  virtual ~Differentiable() {}
  virtual DerivativeBase const & derivative() const = 0;
};


class Function : public Differentiable
{
public:
  Function();
  void evaluate() const;
  DerivativeBase const & derivative() const;

private:
  class Derivative;
  std::auto_ptr<Derivative> _derivative;
};


class Function::Derivative : public DerivativeBase
{
public:
  void evaluateTangent() const;
  void evaluateAdjoint() const;
};


Function::Function()
{
  _derivative = std::auto_ptr<Derivative>(new Derivative);
}

DerivativeBase const & Function::derivative() const
{
  return *_derivative;
}

void Function::evaluate() const
{}

void Function::Derivative::evaluateTangent() const
{}

void Function::Derivative::evaluateAdjoint() const
{}


int main()
{
  Function * function = new Function();

  if (dynamic_cast<Differentiable *>(function))
    {
      function->derivative().evaluateTangent();
      function->derivative().evaluateAdjoint();
    }
}
