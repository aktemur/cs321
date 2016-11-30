%{


%}

%token <string> NAME
%token EOF
%token LPAR RPAR
%token LAMBDA
%token DOT
%token ZERO ONE TWO THREE FOUR
%token SUCC ADD

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
  | LPAR expression RPAR               { $2 }
;

appExpr:
    atomExpr atomExpr                  { App($1, $2) }
  | appExpr atomExpr                   { App($1, $2) }
;

%%
