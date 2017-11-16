# CS321

<http://aktemur.github.io/cs321>

## Deve

This is a simple programming language
where we have arithmetic expressions (add, multiply, subtract, divide),
names, bindings, conditionals, booleans, etc.

Grammar:

```
main ::= exp EOF
exp  ::= INT | BOOL | NAME
       | exp PLUS exp
       | exp STAR exp
       | exp MINUS exp
       | exp SLASH exp
       | exp LESS exp
       | exp LESSEQ exp
       | exp GREATEREQ exp
       | LPAR exp RPAR
       | LPAR exp COMMA exp RPAR
       | FST LPAR exp RPAR
       | SND LPAR exp RPAR
       | MATCH exp WITH LPAR NAME COMMA NAME RPAR ARROW exp END
       | NOT LPAR exp RPAR
       | IF exp THEN exp ELSE exp
       | LET NAME EQUALS exp IN exp
       | LET REC NAME params EQUALS exp IN exp
params ::= NAME
       | NAME params
```

### Interpreter

To run:

```ocaml
# #use "main.ml";;
...
# run "30 + 6 * 2";;
- : value = Int 42
# run "let a = 3
       in let b = 3
          in let c = 5
             in 7 * a - 9 / b + c";;
- : value = Int 23
# run "if true then 42 else 8";;
- : value = Int 42
# run "3 < 4";;
- : value = Bool true
# run "(3, 5 < 8)";;
- : value = Pair (Int 3, Bool true)
# run "((3, 7 + 9), 5 < 8)";;
- : value = Pair (Pair (Int 3, Int 16), Bool true)
# run "let rec f x = x + 2 in f";;
- : value = Closure ("f", ["x"], Binary ("+", Var "x", CstI 2), [])
# run "let rec f x y z = x + 2 in f";;
- : value = Closure ("f", ["x"; "y"; "z"], Binary ("+", Var "x", CstI 2), [])
# run "let x = 15
       in let rec addX y = x + y
          in let x = true
             in addX";;
- : value =
Closure ("addX", ["y"], Binary ("+", Var "x", Var "y"), [("x", Int 15)])
```
