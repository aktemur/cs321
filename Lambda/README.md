# Lambda Calculus

To run, load the `main.ml` file.

* Use the `parse` function to parse
lambda terms.
* Use the `run` function to reduce terms
aggressively.
* Use the `str` function to convert a term to a string.
* Use the `reduce` function to apply a one step of reduction.

```ocaml
$ ocaml
        OCaml version 4.06.0

# #use "main.ml";;
...
# parse;;
- : string -> expr = <fun>
# run;;
- : string -> expr = <fun>
# str;;
- : expr -> string = <fun>
# reduce;;
- : expr -> expr = <fun>
# parse "x y z";;
- : expr = App (App (Var "x", Var "y"), Var "z")
# parse "lambda x . x";;
- : expr = Lambda ("x", Var "x")
# parse "lambda x . x y z";;
- : expr = Lambda ("x", App (App (Var "x", Var "y"), Var "z"))
# parse "w lambda x . x y z";;
- : expr = App (Var "w", Lambda ("x", App (App (Var "x", Var "y"), Var "z")))
# parse "x (y z)";;           
- : expr = App (Var "x", App (Var "y", Var "z"))
# run "(lambda x.x)y";; 
- : expr = Var "y"
# reduce (parse "(lambda x.x)y");;
- : expr = Var "y"
# str(reduce (parse "(lambda x.x)y"));;
- : string = "y"
# let w = parse "(lambda x.x x)(lambda x.x x)";;
val w : expr =
App (Lambda ("x", App (Var "x", Var "x")),
  Lambda ("x", App (Var "x", Var "x")))
# reduce w;;
- : expr =
App (Lambda ("x", App (Var "x", Var "x")),
  Lambda ("x", App (Var "x", Var "x")))
```
