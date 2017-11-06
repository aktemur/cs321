# CS321

<http://aktemur.github.io/cs321>

## Deve

This is a simple programming language
where we have arithmetic expressions (add, multiply, subtract, divide),
names, bindings, conditionals, relational operators,
and boolean literals.

Grammar:

```
main ::= exp EOF
exp  ::= INT
       | NAME
       | LET NAME EQUALS exp IN exp
```

### Interpreter

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
# scan "++*-/";;
- : token list = [PLUS; PLUS; STAR; MINUS; SLASH; EOF]
# scan "++ *   -/";;
- : token list = [PLUS; PLUS; STAR; MINUS; SLASH; EOF]
# scan "321 +4567 9";;
- : token list = [INT 321; PLUS; INT 4567; INT 9; EOF]
# scan "cs321 + 9 * caMeL";;
- : token list = [NAME "cs321"; PLUS; INT 9; STAR; NAME "caMeL"; EOF]
# scan "let x = 5 in if x * dummy then 321 else ";;
- : token list =
[LET; NAME "x"; EQUALS; INT 5; IN; IF; NAME "x"; STAR; NAME "dummy"; THEN;
 INT 321; ELSE; EOF]
# scan "x % abc Upper ??@ hey";;
- : token list =
[NAME "x"; ERROR '%'; NAME "abc"; ERROR 'U'; NAME "pper"; ERROR '?';
 ERROR '?'; ERROR '@'; NAME "hey"; EOF]
```

### Parser

Sample run:

```ocaml
# #use "deve.ml";;
...
# #use "lexer.ml";;
...
# #use "parser.ml";;
...
#  parse "5";;
- : exp = CstI 5
# parse "ozu";;
- : exp = Var "ozu"
# parse "let x = 4 in foo";;
- : exp = LetIn ("x", CstI 4, Var "foo")
# parse "let x = let y = z in 42 in foo";;
- : exp = LetIn ("x", LetIn ("y", Var "z", CstI 42), Var "foo")
# parse "let x = let y = z in 42 in let f = 8 in 7";;
- : exp =
LetIn ("x", LetIn ("y", Var "z", CstI 42), LetIn ("f", CstI 8, CstI 7))
```

