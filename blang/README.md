# blang

A toy BASIC interpreter written in C++. Its aims to be:
* a learning exercise on how to write interpeters
* simple, one file
* an experiment for possible integration into the neoleo spreadsheet

## Features/non-features

* keywords: else, for, if, let, next, print, then, wend, while
* relational operators (<, <=, >, >=, ==, !=), work like normal operators (e.g. you can say 1 < x < 5)
* logical operators can be faked ( * for AND, + for OR)
* all variables are doubles, global, and do not have to be pre-declared. No strings
* comments start with a '

## Subprojects

* [bcode](bcode) - a bytecode compiler experiment
* [v2](v2) - an attempt at a rewrite of a parser based on s-expr
* [v3](v3) - a complete BASIC interpreter in 760 lines of code
* [v4](v4) - going beyond version 3 to include a bunch of other stuff (**BEST**)
* [v5](v5) - starting out again, this time using lex/yacc. Requires C++17
* lisp - an interpreter for lisp copied from github


## Implementations

Some implementations of BASIC are: basic256, brandy, bwbasic, sdlbasic, yabasic.
There are more at [
thefreecountry](https://www.thefreecountry.com/compilers/basic.shtml).


## Unlcassified

* [zx81](zx81.md) - some notes about ZX81 assembler


## References

* [Scheme 9 from Empty Space](http://t3x.org/s9fes/) - R4RS scheme implementation, which seems to be regarded highly
* [Small BSIC Interpreters](https://sites.google.com/site/smallbasicinterpreters/source-code) - some implementations of BASIC, with source code

* [Writing a very simple lexical analyser in C++](https://stackoverflow.com/questions/34229328/writing-a-very-simple-lexical-analyser-in-c)
