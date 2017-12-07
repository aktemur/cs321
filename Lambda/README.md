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

## Church Encodings

Encodings are defined at

<https://github.com/aktemur/cs321/blob/master/Lambda/parser.ml#L80>

We use the shortcut names only for convenience.
Usages of `add`, `mult`, `2`, etc. are simply replaced by their lambda encoding.
Computation happens using the pure lambda syntax.

### Numbers

```ocaml
# parse "0";;
- : expr = Lambda ("f", Lambda ("x", Var "x"))
# str(parse "0");;
- : string = "(lambda f.(lambda x.x))"
# str(parse "1");;
- : string = "(lambda f.(lambda x.(f x)))"
# str(parse "2");;
- : string = "(lambda f.(lambda x.(f (f x))))"
# str(parse "3");;
- : string = "(lambda f.(lambda x.(f (f (f x)))))"
# str(parse "succ");;
- : string = "(lambda n.(lambda f.(lambda x.(f ((n f) x)))))"
# str(parse "add");;
- : string = "(lambda m.(lambda n.(lambda f.(lambda x.((m f) ((n f) x))))))"
# str(parse "mult");;
- : string = "(lambda m.(lambda n.(lambda f.(lambda x.((m (n f)) x)))))"
# str(parse "succ (succ 2)");;
- : string =
"((lambda n.(lambda f.(lambda x.(f ((n f) x))))) ((lambda n.(lambda f.(lambda x.(f ((n f) x))))) (lambda f.(lambda x.(f (f x))))))"
# str(run "succ (succ 2)");;
- : string = "(lambda f.(lambda x.(f (f (f (f x))))))"
# str(run "add 2 3");;
- : string = "(lambda f.(lambda x.(f (f (f (f (f x)))))))"
# str(run "mult 2 3");;
- : string = "(lambda f.(lambda x.(f (f (f (f (f (f x))))))))"
# str(run "mult (mult 2 3) (add 1 3)");;
- : string =
"(lambda f.(lambda x.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))))))))))))"
# str(run "pred 3");; (* predecessor function that returns the preceding number *)
- : string = "(lambda f.(lambda x.(f (f x))))"
# str(run "pred (mult 2 3)");;
- : string = "(lambda f.(lambda x.(f (f (f (f (f x)))))))"
# str(run "pred (succ 0)");;
- : string = "(lambda f.(lambda x.x))"
```

### Booleans

```ocaml
# str(parse "true");;
- : string = "(lambda a.(lambda b.a))"
# str(parse "false");;
- : string = "(lambda a.(lambda b.b))"
# str(parse "if");;   
- : string = "(lambda c.(lambda t.(lambda e.((c t) e))))"
# str(parse "isZero");;
- : string =
"(lambda n.((n (lambda x.(lambda a.(lambda b.b)))) (lambda a.(lambda b.a))))"
# str(run "isZero 0");;
- : string = "(lambda a.(lambda b.a))"
# str(run "isZero 2");;
- : string = "(lambda a.(lambda b.b))"
# str(run "if (isZero (mult 3 0)) (add 2 3) (succ 1)");;
- : string = "(lambda f.(lambda x.(f (f (f (f (f x)))))))"
```
