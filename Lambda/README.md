# Lambda Calculus

To run, first generate the grammar and lexer files
from the specifications, as follows:

```
$ ocamlyacc grammar.mly
$ ocamllex lexer.mll
```

The `grammar.ml` and `lexer.ml` are generated.
Next, open the OCaml REPL and load the `gather.ml`
file, which puts everything together by loading
`lambda.ml`, `grammar.ml`, and `lexer.ml`,
and also by defining the following `parse` and `run` functions:

```ocaml
# let parse s = main tokenize (Lexing.from_string s);;
val parse : string -> expr = <fun>
# let run s = eval (parse s);;
val run : string -> int = <fun>
```

Here are a few tests.
Ignore the warning about the use of backslash.

```ocaml
# parse "(\x.x)y";;
Warning 14: illegal backslash escape in string.
- : expr = App (Lambda ("x", Var "x"), Var "y")
# str(parse "(\x.x)y");;
Warning 14: illegal backslash escape in string.
- : string = "((\\x.x) y)"
# str(eval (parse "(\x.x)y"));;
Warning 14: illegal backslash escape in string.
- : string = "y"
# str(run "(\x.x)y");;         
Warning 14: illegal backslash escape in string.
- : string = "y"
# str(run "(\f.\x.f x)(\y.y)(\z.z z)");;
Warning 14: illegal backslash escape in string.
Warning 14: illegal backslash escape in string.
Warning 14: illegal backslash escape in string.
Warning 14: illegal backslash escape in string.
- : string = "(\\z.(z z))"
# let omega = "(\x.x x)(\x.x x)";;
Warning 14: illegal backslash escape in string.
Warning 14: illegal backslash escape in string.
val omega : string = "(\\x.x x)(\\x.x x)"
# run omega;; 
(* infinite loop *)
```

Some tests with **Church encodings**:

```ocaml
# parse "one";;
- : expr = Lambda ("f", Lambda ("x", App (Var "f", Var "x")))
# parse "two";;
- : expr = Lambda ("f", Lambda ("x", App (Var "f", App (Var "f", Var "x"))))
# parse "three";;
- : expr =
Lambda ("f",
 Lambda ("x", App (Var "f", App (Var "f", App (Var "f", Var "x")))))
# str(parse "three");;
- : string = "(\\f.(\\x.(f (f (f x)))))"
# str(parse "succ");;  
- : string = "(\\n.(\\f.(\\x.(f ((n f) x)))))"
# str(parse "add");; 
- : string = "(\\m.(\\n.(\\f.(\\x.((m f) ((n f) x))))))"
# str(run "succ two");;
- : string = "(\\f.(\\x.(f (f (f x)))))"
# str(run "succ three");;
- : string = "(\\f.(\\x.(f (f (f (f x))))))"
# str(run "succ four");; 
- : string = "(\\f.(\\x.(f (f (f (f (f x)))))))"
# str(run "add four two");;
- : string = "(\\f.(\\x.(f (f (f (f (f (f x))))))))"
# str(run "add (add four two) three");;
- : string = "(\\f.(\\x.(f (f (f (f (f (f (f (f (f x)))))))))))"
```
