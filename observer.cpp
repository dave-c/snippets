#include <iostream>
#include <vector>

class Observer;

class Subject {
public:
  void attach(Observer *observer) {
    _observer.push_back(observer);
  }
  void notify();
private:
  std::vector<class Observer*> _observer;
};

class Observer {
public:
  Observer(Subject *subject)
    : _subject(subject) {
    _subject->attach(this);
  }
  virtual void update() = 0;
protected:
  template <class _Subject_>
  _Subject_ *getSubject(_Subject_ *subject) {
    return dynamic_cast<_Subject_*>(subject);
  }
private:
  Subject *_subject;
};

void Subject::notify() {
  for (int i = 0; i < _observer.size(); i++)
    _observer[i]->update();
}


class TextEditor: public Subject {
public:
  void addText(std::string text) {
    _text += text;
    this->notify();
  }
  std::string const &getText() const {
    return _text;
  }
private:
  std::string _text;
};

class WordCount: public Observer {
public:
  WordCount(TextEditor *textEditor)
    : Observer(textEditor), _textEditor(textEditor), _charCount(0) {}
  void update() {
    _charCount = getSubject<TextEditor>(_textEditor)->getText().size();
  }
  int getCharacterCount() { return _charCount; }
private:
  TextEditor *_textEditor;
  int _charCount;
};

int main() {
  TextEditor textEditor;
  WordCount wordCount(&textEditor);

  textEditor.addText(std::string("hello"));
  std::cout << wordCount.getCharacterCount() << " " << textEditor.getText() << std::endl;

  textEditor.addText(std::string(" world"));
  std::cout << wordCount.getCharacterCount() << " " << textEditor.getText() << std::endl;
}
