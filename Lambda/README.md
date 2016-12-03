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

Multiplication and "predecessor" function:

```ocaml
# str(run "mult two three");;
- : string = "(\\f.(\\x.(f (f (f (f (f (f x))))))))"
# str(run "mult (mult two three) three");;
- : string =
"(\\f.(\\x.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))))))"
# str(run "pred (mult two three)");;      
- : string = "(\\f.(\\x.(f (f (f (f (f x)))))))"
# str(run "pred (pred (mult two three))");;
- : string = "(\\f.(\\x.(f (f (f (f x))))))"
```

Booleans, "if", and "isZero" predicate:

```ocaml
# str(run "true");;       
- : string = "(\\a.(\\b.a))"
# str(run "false");;
- : string = "(\\a.(\\b.b))"
# str(run "isZero zero");;
- : string = "(\\a.(\\b.a))"
# str(run "isZero one");; 
- : string = "(\\a.(\\b.b))"
# str(run "if (isZero (pred one)) three four");;
- : string = "(\\f.(\\x.(f (f (f x)))))"
# str(run "if (isZero one) three four");;       
- : string = "(\\f.(\\x.(f (f (f (f x))))))"
```

Recursion, using fix-point calculation via a Y-combinator.
Below, we are calculation 3! and 4!.

```ocaml
# str(run "(Y (\fact.\m.if (isZero m)
                        one
                        (mult m (fact (pred m))))
           ) three");;
- : string = "(\\f.(\\x.(f (f (f (f (f (f x))))))))"
# str(run "(Y (\fact.\m.if (isZero m)            
                        one                      
                        (mult m (fact (pred m))))
           ) four");;                            
- : string =
"(\\f.(\\x.(f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f (f x))))))))))))))))))))))))))"
```

Note that the programs below are pure lambda terms;
"if", "pred", "mult" and other names with special meanings are
just syntactic convenience. They are converted to plain lambda terms by the parser.
E.g:

```ocaml
# str(parse "(Y (\fact.\m.if (isZero m)        
                          one                  
                          (mult m (fact (pred m))))
             ) four");;                            
- : string =
"(((\\h.((\\x.(\\a.((h (x x)) a))) (\\x.(\\a.((h (x x)) a)))))
(\\fact.(\\m.((((\\cond.(\\then.(\\else.((cond then) else))))
((\\n.((n (\\x.(\\a.(\\b.b)))) (\\a.(\\b.a)))) m)) (\\f.(\\x.(f x))))
(((\\m.(\\n.(\\f.(\\x.((m (n f)) x))))) m)
(fact ((\\n.(\\f.(\\x.(((n (\\g.(\\h.(h (g f))))) (\\u.x)) (\\u.u))))) m)))))))
(\\f.(\\x.(f (f (f (f x)))))))"
```
