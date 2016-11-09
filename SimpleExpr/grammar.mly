%{


%}

%token <int> INTEGER
%token <string> NAME
%token EOF
%token PLUS STAR MINUS SLASH
%token LET EQ IN
%token LEFTANGLE
%token IF THEN ELSE
%token LPAR RPAR
%token NOT
%token GTEQ
%token MIN MAX COMMA
%token FST SND
%token MATCH WITH ARROW
%token FUN

/* Precedence definitions: */
/* lowest precedence  */
%nonassoc IN ELSE ARROW
%left EQ
%nonassoc LEFTANGLE GTEQ
%left PLUS MINUS
%left STAR SLASH
/* highest precedence  */

%start main
%type <expr> main

%%

main:
    expression EOF                     { $1 }
;

expression:
    atomExpr                           { $1 }
  | expression PLUS expression         { Prim("+", $1, $3)  }
  | expression STAR expression         { Prim("*", $1, $3)  }
  | expression MINUS expression        { Prim("-", $1, $3) }
  | expression SLASH expression        { Prim("/", $1, $3) }
  | expression EQ expression           { Prim("=", $1, $3) }
  | expression LEFTANGLE expression    { Prim("<", $1, $3) }
  | expression GTEQ expression         { Unary("not", Prim("<", $1, $3)) }
  | LET NAME EQ expression IN expression { Let($2, $4, $6) }
  | IF expression THEN expression ELSE expression { If($2, $4, $6) }
  | MATCH expression WITH LPAR NAME COMMA NAME RPAR ARROW expression
                                       { MatchPair($2, $5, $7, $10) }
  | FUN NAME ARROW expression          { Fun($2, $4) }
  | appExpr                            { $1 }
;

atomExpr:
    INTEGER                            { CstI $1 }
  | NAME                               { Var $1  }
  | LPAR expression RPAR               { $2 }
  | NOT LPAR expression RPAR           { Unary("not", $3) }
  | MIN LPAR expression COMMA expression RPAR { Prim("min", $3, $5) }
  | MAX LPAR expression COMMA expression RPAR { Prim("max", $3, $5) }
  | LPAR expression COMMA expression RPAR { Prim(",", $2, $4) }
  | FST LPAR expression RPAR           { Unary("fst", $3) }
  | SND LPAR expression RPAR           { Unary("snd", $3) }
;

appExpr:
    atomExpr atomExpr                  { App($1, $2) }
  | appExpr atomExpr                   { App($1, $2) }
;

%%
