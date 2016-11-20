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

## Type Inference

We now have type inference for our language.
The `run` function reports both the inferred type
of its input, and the value it reduces to.
You can use the `typeOf` function to only infer the type
of an expression.
E.g.:

```ocaml
# typeOf (parse "4 + 5");;
- : tip = IntTy
# typeOf (parse "fun x -> x + 5");; 
- : tip = FunTy (IntTy, IntTy)
# typeOf (parse "fun x -> if x then 5 else 8");;
- : tip = FunTy (BoolTy, IntTy)
# run "4 + 5";;
- : tip * value = (IntTy, Int 9)
# run "let add x y = x + y in add 4 6";;
- : tip * value = (IntTy, Int 10)
# run "let add x y = x + y in add 4";;  
- : tip * value =
(FunTy (IntTy, IntTy),
 Closure ("y", Prim ("+", Var "x", Var "y"), [("x", Int 4)]))
# run "let add x y = x + y in add";;  
- : tip * value =
(FunTy (IntTy, FunTy (IntTy, IntTy)),
 Closure ("x", Fun ("y", Prim ("+", Var "x", Var "y")), []))
# run "let rev p = match p with (x,y) -> (y,x) in rev";;
- : tip * value =
(FunTy (PairTy (Alpha 13, Alpha 12), PairTy (Alpha 12, Alpha 13)),
 Closure ("p", MatchPair (Var "p", "x", "y", Prim (",", Var "y", Var "x")),
  []))
# run "let rev p = match p with (x,y) -> (y,x) in rev (4, 5<6)";;
- : tip * value = (PairTy (BoolTy, IntTy), Pair (Bool true, Int 4))
```
