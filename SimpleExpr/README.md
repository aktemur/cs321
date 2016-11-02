To run, first generate the grammar and lexer files
from the specifications, as follows:

```
$ ocamlyacc grammar.mly
$ ocamllex lexer.mll
```

The `grammar.ml` and `lexer.ml` are generated.
Next, open the OCaml REPL and load the `gather.ml`
file, which puts everything together by loading
`simpleExpr.ml`, `grammar.ml`, and `lexer.ml`,
and also by defining the following `parse` and `run` functions:

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
