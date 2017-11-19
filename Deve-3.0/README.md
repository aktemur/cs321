# CS321

<http://aktemur.github.io/cs321>

## Deve

This is a simple programming language
where we have arithmetic expressions (add, multiply, subtract, divide),
names, bindings, conditionals, booleans, and functions.

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
       | MATCH exp WITH LPAR NAME COMMA NAME RPAR ARROW exp
       | IF exp THEN exp ELSE exp
       | LET NAME EQUALS exp IN exp
       | LET NAME NAME EQUALS exp IN exp
       | LET REC NAME NAME EQUALS exp IN exp
       | FUN NAME ARROW exp
       | exp exp
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
# run "let rec fact n =
         if n <= 0 then 1 else n * fact (n-1)
       in fact 6";;
- : value = Int 720
# run "let rec fib n =
         if n <= 0 then 1 
         else if n <= 1 then 1
         else fib (n-1) + fib (n-2)
       in (fib 5, (fib 6, fib 7))";;
- : value = Pair (Int 8, Pair (Int 13, Int 21))
# run "let rec power x = fun n ->
         if n <= 0 then 1 else x * power x (n-1)
       in power 3 4";;
- : value = Int 81
```
