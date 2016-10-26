To run, first generate the grammar and lexer files
from the specifications, as follows:

```
$ ocamlyacc grammar.mly
$ ocamllex lexer.mll
```

The `grammar.ml` and `lexer.ml` are generated.
Next, open the OCaml REPL and load the files in the following
order:

```ocaml
# #use "simpleExpr.ml";;
# #use "grammar.ml";;
# #use "lexer.ml";;
```

This will give us

* the `tokenize` function from `lexer.ml` that takes a lexing buffer
and returns the next token:

```ocaml
# tokenize;;
- : Lexing.lexbuf -> token = <fun>
```

* the `main` function from `grammar.ml` that takes tokenization function and 
a buffer, and returns an `expr`:

```ocaml
# main;;
- : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> expr = <fun>
```

Remember that you can create lexing buffers from strings using the `Lexing` module:

```ocaml
# let buffer = Lexing.from_string "abc 1234 xy35 + -    cool";;
```

And now you can define a `parse` function to convert strings
to expressions, and a `run` function to evaluate
inputs given as strings.

```ocaml
# let parse s = main tokenize (Lexing.from_string s);;
val parse : string -> expr = <fun>
# let run s = eval (parse s) [];;
val run : string -> int = <fun>
```

Here are a few tests:

```ocaml
# parse "4 + 7 * 3";;
- : expr = Plus (CstI 4, Star (CstI 7, CstI 3))
# parse "4 * 7 + 3";;
- : expr = Plus (Star (CstI 4, CstI 7), CstI 3)
# parse "4 - 7 - 3";;
- : expr = Minus (Minus (CstI 4, CstI 7), CstI 3)
# run "4 - 7 - 3";;
- : int = -6
# run "4 * 7 + 3";;
- : int = 31
```
