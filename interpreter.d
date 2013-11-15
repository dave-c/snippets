import std.stdio;
import std.getopt;
import std.file;
import std.regex;
import std.conv;

/+
 `scan` returns the next character
 `tokenise` returns the next token and its type
 `parse` generates the abstract syntax tree
 `interpret` evaluates the abstract syntax tree
 `generate` writes the abstract syntax tree to x86-64 assembler for yasm
 +/

enum Mode { scan, tokenise, parse, interpret, generate, };
Mode mode = Mode.scan;


void main(string[] args)
{
  getopt(args, "mode", &mode);

  string[] inputs;
  foreach (ref arg; args[1..$])
    {
      if (exists(arg))
        {
          ++inputs.length;
          inputs[$-1] = arg;
        }
    }

  foreach (input; inputs)
    {
      auto scanner = Scanner(input);
      // scanner.evaluate();

      auto lexer = Lexer(scanner);
      lexer.evaluate();
    }
}


struct Scanner
{
  this(string fileName)
  {
    this.text = readText(fileName);
  }

  void evaluate()
  {
    char e;
    while (getNext(e))
      {
        writeln(e);
      }
  }

  bool getNext(out char e)
  {
    bool success = false;
    if (offset < this.text.length)
      {
        success = true;
        e = this.text[offset];
        ++offset;
      }

    return success;
  }

  string text;
  int offset = 0;
  int line = 0;
  int col = 0;
}


struct Lexer
{
  this(ref Scanner scanner)
  {
    this.scanner = scanner;
    this.scanner.getNext(this.e);
  }

  void evaluate()
  {
    string token;
    while (getNext(token))
      {
        writeln(token);
      }
  }

  bool getNext(out string token)
  {
    bool success = false;
    char e;
    token = "";
    while (this.scanner.getNext(e))
      {
        success = true;
        if (match(to!string(e), regex(r"[_a-zA-Z]")).captures.length > 0)
          {
            token ~= e;
            this.scanner.getNext(e);
            while (match(to!string(e), regex(r"[_a-zA-Z0-9]")).captures.length > 0)
              {
                token ~= e;
                this.scanner.getNext(e);
              }
            return
          }
      }

    return success;
  }

  Scanner scanner;
  char e;
  enum Token { unrecognised, indetifier, };
}
