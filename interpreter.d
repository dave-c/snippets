import std.stdio;
import std.getopt;
import std.file;
import std.regex;
import std.conv;
import std.uni;
import std.ascii;

/+
 `scan` returns the next character
 `tokenise` returns the next token and its type
 `parse` generates the abstract syntax tree
 `interpret` evaluates the abstract syntax tree
 `generate` writes the abstract syntax tree to x86-64 assembler for yasm
 +/

enum Mode { scan, tokenise, parse, interpret, generate, }
Mode mode = Mode.scan;


void main(string[] args)
{
  getopt(args, "mode", &mode);

  if (args.length < 2)
    {
      writeln("no files provided");
      return;
    }

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
    writeln("Running the scanner...");
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

  bool peekNext(out char e)
  {
    bool success = false;
    if (offset < this.text.length)
      {
        success = true;
        e = this.text[offset];
      }

    return success;
  }

  void increment()
  {
    ++offset;
  }

  void clear()
  {
    offset = 0;
    line = 0;
    col = 0;
  }

  string text;
  int offset = 0;
  int line = 0;
  int col = 0;
}


string graphicalChar(char e)
{
  switch (e)
    {
    case ' ': return "space";
    case '\n': return "newline";
    case '\t': return "tab";
    default: return to!string(e);
    }
}


struct SpecialToken
{
  string[] keyword = ["import", "return"];
  string[] primative = ["void", "int"];
  char[] whitespace = ['\n'];
  string[] symbol = ["=", "!", "(", ")"];
}


struct Token
{
  enum Type { unrecognised, keyword, primative, whitespace, symbol, identifier, }
  Type type = Type.unrecognised;
  string name = "";
  int offset = 0;
  int length = 0;
}

struct IdentifierToken
{
  bool hasFirstChar(char e)
  {
    return std.ascii.isAlpha(e);
  }

  bool hasNextChar(char e)
  {
    return std.ascii.isAlphaNum(e);
  }
}

struct NumberToken
{
}

struct StringToken
{
}

struct WhitespaceToken
{
}


struct Lexer
{
  this(ref Scanner scanner)
  {
    this.scanner = scanner;
    this.scanner.clear();
  }

  void evaluate()
  {
    writeln("Running the lexer...");
    Token token;
    while (getNext(token))
      {
        writeln(to!string(token.type), ": ", token.name);
      }
  }

  bool getNext(out Token token)
  {
    bool success = false;

    char e;
    token.offset = this.scanner.offset;
    token.length = 1;

    while (this.scanner.getNext(e))
      {
        success = true;

        if (IdentifierToken().hasFirstChar(e))
          {
            char ep;
            while (this.scanner.peekNext(ep) && IdentifierToken().hasNextChar(ep))
              {
                this.scanner.increment();
                ++token.length;
              }
            token.type = Token.Type.identifier;
            token.name = this.scanner.text[token.offset..token.offset + token.length];
            break;
          }

        else
          {
            token.type = Token.Type.unrecognised;
            if (std.ascii.isGraphical(e))
              {
                token.name =  "'" ~ to!string(e) ~ "'";
              }
            else
              {
                token.name = graphicalChar(e);
              }
            break;
          }
      }

    return success;
  }

  Scanner scanner;
}
