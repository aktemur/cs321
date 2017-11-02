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
# allTokens "++ *   -/";;
- : token list = [PLUS; PLUS; STAR; MINUS; SLASH; EOF]
# allTokens "321 +4567 9";;
- : token list = [INT 321; PLUS; INT 4567; INT 9; EOF]
# allTokens "cs321 + 9 * caMeL";;
- : token list = [NAME "cs321"; PLUS; INT 9; STAR; NAME "caMeL"; EOF]
# allTokens "let x = 5 in if x * dummy then 321 else ";;
- : token list =
[LET; NAME "x"; EQUALS; INT 5; IN; IF; NAME "x"; STAR; NAME "dummy"; THEN;
 INT 321; ELSE; EOF]
```
