%{


%}

%token <string> NAME
%token EOF
%token LPAR RPAR
%token LAMBDA
%token DOT
%token ZERO ONE TWO THREE FOUR
%token SUCC ADD
%token MULT PRED
%token IF TRUE FALSE ISZERO
%token YCOMB

%start main
%type <expr> main

%%

main:
    expression EOF                     { $1 }
;

expression:
    atomExpr                           { $1 }
  | appExpr                            { $1 }
  | LAMBDA NAME DOT expression         { Lambda($2, $4) }
;

atomExpr:
    NAME                               { Var $1  }
  | ZERO                               { Lambda("f", Lambda("x", Var "x")) } 
  | ONE                                { Lambda("f", Lambda("x", App(Var "f", Var "x"))) } 
  | TWO                                { Lambda("f", Lambda("x", App(Var "f", App(Var "f", Var "x")))) } 
  | THREE                              { Lambda("f", Lambda("x", App(Var "f", App(Var "f", App(Var "f", Var "x"))))) } 
  | FOUR                               { Lambda("f", Lambda("x", App(Var "f", App(Var "f", App(Var "f", App(Var "f", Var "x")))))) } 
  | SUCC      { Lambda("n", Lambda("f", Lambda("x",
                     App(Var "f", App(App(Var "n", Var "f"), Var "x"))))) } 
  | ADD       { Lambda("m", Lambda("n", Lambda("f", Lambda("x",
                     App(App(Var "m", Var "f"), App(App(Var "n", Var "f"), Var "x")))))) } 
  | MULT      { Lambda("m", Lambda("n", Lambda("f", Lambda("x",
                     App(App(Var "m", App(Var "n", Var "f")), Var "x"))))) } 
  | PRED      { Lambda("n", Lambda("f", Lambda("x",
                     App(App(App(Var "n", Lambda("g", Lambda("h", App(Var "h", App(Var "g", Var "f"))))),
                             Lambda("u", Var "x")),
                         Lambda("u", Var "u"))))) } 
  | TRUE      { Lambda("a", Lambda("b", Var "a")) }
  | FALSE     { Lambda("a", Lambda("b", Var "b")) }
  | IF        { Lambda("cond", Lambda("then", Lambda("else", App(App(Var "cond", Var "then"), Var "else")))) }
  | ISZERO    { Lambda("n", App(App(Var "n", Lambda("x", Lambda("a", Lambda("b", Var "b")))),
                                Lambda("a", Lambda("b", Var "a")))) }
  /* Definition of Y-combinator taken from PLC, page 85. */
  | YCOMB     { Lambda("h", App(Lambda("x", Lambda("a", App(App(Var "h", App(Var "x", Var "x")), Var "a"))),
                                Lambda("x", Lambda("a", App(App(Var "h", App(Var "x", Var "x")), Var "a"))))) } 
  | LPAR expression RPAR               { $2 }
;

appExpr:
    atomExpr atomExpr                  { App($1, $2) }
  | appExpr atomExpr                   { App($1, $2) }
;

%%
