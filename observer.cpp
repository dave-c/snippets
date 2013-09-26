// based on:
// http://rtmatheson.com/2010/03/working-on-the-subject-observer-pattern/

#include <vector>
#include <string>
#include <iostream>


class Subject;


class Observer
{
public:
  virtual void notify(Subject* s) = 0;
  virtual ~Observer() {};
};


class Subject
{
public:
  virtual ~Subject() {};
  void register_observer(Observer* o)
  {
    observers.push_back(o);
  }

protected:
  void notify_observers()
  {
    std::vector<Observer*>::const_iterator iter;
    for (iter = observers.begin(); iter != observers.end(); ++iter)
      (*iter)->notify(this);
  }

private:
  std::vector<Observer*> observers;
};


class Alarm: public Subject
{
public:
  void trigger()
  {
    std::cout << "The alarm has been triggerd"
              << std::endl;
    notify_observers();
  }

  int const get_loudness()
  {
    return 100;
  }
};


class Horn: public Observer
{
public:
  virtual void notify(Subject* s)
  {
    if (Alarm *a = dynamic_cast<Alarm*>(s))
      std::cout << "Sound the horn at "
                << a->get_loudness() << "dB"
                << std::endl;
  }
};


int main()
{
  Alarm a = Alarm();
  Horn h = Horn();
  a.register_observer(&h);
  a.trigger();
  return 0;
}
