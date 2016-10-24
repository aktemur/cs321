To run, first generate the grammar and lexer files
from the specifications, as follows:

```
$ ocamlyacc grammar.mly
$ ocamllex lexer.mll
```

A file named `grammar.mli` will be generated (in addition to
`grammar.ml` and `lexer.ml`). The `.mli` file contains the
`token` type definition. Let's take a look at it:

```ocaml
$ cat grammar.mli
type token =
| INTEGER of (int)
| NAME of (string)
| EOF
| PLUS
| STAR
| MINUS
| SLASH

val expression :
(Lexing.lexbuf  -> token) -> Lexing.lexbuf -> expr
```

For the time being, we have tokens for integer literals,
names, the four arithmetic operators, and the end-of-file marker (`EOF`).
We will later add tokens for other things,
including keywords such as `let`, `in`, `if`, `then`, etc. 

Next, open the OCaml REPL and load the files in the following
order:

```ocaml
# #use "simpleExpr.ml";;
# #use "grammar.ml";;
# #use "lexer.ml";;
```

This will give us the `tokenize` function that takes a lexing buffer
and returns the next token:

```ocaml
# tokenize;;
- : Lexing.lexbuf -> token = <fun>
```

You can create lexing buffers from strings using the `Lexing` module:

```ocaml
# let buffer = Lexing.from_string "abc 1234 xy35 + -    cool";;
```

And now you can apply `tokenize` on `buffer`.
Each application will return you the next token:

```ocaml
# tokenize buffer;;;
- : token = NAME "abc"
# tokenize buffer;;;
- : token = INTEGER 1234
# tokenize buffer;;;
- : token = NAME "xy35"
# tokenize buffer;;;
- : token = PLUS
# tokenize buffer;;;
- : token = MINUS
# tokenize buffer;;;
- : token = NAME "cool"
# tokenize buffer;;;
- : token = EOF
# tokenize buffer;;;
- : token = EOF
```

You can in fact write a function that will collect all
the tokens in a given string:

```ocaml
# let allTokens s =
    let rec aux buffer =
      let token = tokenize buffer in
      if token = EOF then [token]
      else token::(aux buffer)
    in aux (Lexing.from_string s);;
val allTokens : string -> token list = <fun>
# allTokens "abc 1234 xy35 + -    cool";;
- : token list =
[NAME "abc"; INTEGER 1234; NAME "xy35"; PLUS; MINUS; NAME "cool"; EOF]
# allTokens "x + y * 10";;
- : token list = [NAME "x"; PLUS; NAME "y"; STAR; INTEGER 10; EOF]
# allTokens "let if then in Hello Test";;
- : token list =
[NAME "let"; NAME "if"; NAME "then"; NAME "in"; NAME "Hello"; NAME "Test";
 EOF]
# allTokens "invalid_name";;
Exception: Failure "Lexer error: illegal symbol".
# allTokens "123abc";;
- : token list = [INTEGER 123; NAME "abc"; EOF]
# allTokens "x-123";;
- : token list = [NAME "x"; MINUS; INTEGER 123; EOF]
# allTokens "x % y";;
Exception: Failure "Lexer error: illegal symbol".
```

