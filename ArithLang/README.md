# CS321

<http://aktemur.github.io/cs321>

## ArithLang

This is a very simple programming language
where we have arithmetic expressions (add, multiply, subtract, divide),
and names only.

To run:

```
# #use "arith.ml";;
...
# eval e1 [];;
- : int = 42
# eval e1 env1;;
- : int = 42
# eval e4 env1;;
- : int = -5
# eval e4 env2;;
- : int = -96
```

