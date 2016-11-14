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

## Types

With the addition of type annotations,
functions shall be written where each parameter
is enclosed in parentheses and is written together with its type.

A type is either plain `int` or `bool`,
a function type (e.g. `int -> bool -> int`),
or a pair type (e.g. `(int * bool)`).

```ocaml
# parse "fun (x:int) -> 5";;
- : expr = Fun ("x", IntTy, CstI 5)
# parse "fun (x:bool) -> 5";;
- : expr = Fun ("x", BoolTy, CstI 5)
# parse "fun (x: int -> int) -> 5";;
- : expr = Fun ("x", FunTy (IntTy, IntTy), CstI 5)
# parse "fun (x: int -> int -> int) -> 5";;
- : expr = Fun ("x", FunTy (IntTy, FunTy (IntTy, IntTy)), CstI 5)
# parse "fun (x: (int -> bool) -> int) -> 5";;
- : expr = Fun ("x", FunTy (FunTy (IntTy, BoolTy), IntTy), CstI 5)
# parse "fun (x: (int * bool) -> int) -> 5";; 
- : expr = Fun ("x", FunTy (PairTy (IntTy, BoolTy), IntTy), CstI 5)
# parse "fun (x: int -> (int * int)) -> 5";;  
- : expr = Fun ("x", FunTy (IntTy, PairTy (IntTy, IntTy)), CstI 5)
# parse "fun (x: int) (y:bool) (z: int) -> 5";;
- : expr = Fun ("x", IntTy, Fun ("y", BoolTy, Fun ("z", IntTy, CstI 5)))
# parse "let f (x:int) (y:int) = x + y in f 3 4";;
- : expr =
Let ("f", Fun ("x", IntTy, Fun ("y", IntTy, Prim ("+", Var "x", Var "y"))),
 App (App (Var "f", CstI 3), CstI 4))
```
