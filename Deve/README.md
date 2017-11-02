# CS321

<http://aktemur.github.io/cs321>

## Deve

This is a simple programming language
where we have arithmetic expressions (add, multiply, subtract, divide),
names, bindings, conditionals, relational operators,
and boolean literals

To run:

```ocaml
# #use "deve.ml";;
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

### Lexer

Sample run:

```ocaml
# #use "lexer.ml";;
...
# allTokens "++*-/";;
- : token list = [PLUS; PLUS; STAR; MINUS; SLASH; EOF]
```
