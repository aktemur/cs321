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

/* Precedence definitions: */
/* lowest precedence  */
%nonassoc IN ELSE
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
    INTEGER                            { CstI $1 }
  | NAME                               { Var $1  }
  | expression PLUS expression         { Prim("+", $1, $3)  }
  | expression STAR expression         { Prim("*", $1, $3)  }
  | expression MINUS expression        { Prim("-", $1, $3) }
  | expression SLASH expression        { Prim("/", $1, $3) }
  | expression EQ expression           { Prim("=", $1, $3) }
  | expression LEFTANGLE expression    { Prim("<", $1, $3) }
  | expression GTEQ expression         { Unary("not", Prim("<", $1, $3)) }
  | LET NAME EQ expression IN expression { Let($2, $4, $6) }
  | IF expression THEN expression ELSE expression { If($2, $4, $6) }
  | LPAR expression RPAR               { $2 }
  | NOT LPAR expression RPAR           { Unary("not", $3) }
  | MIN LPAR expression COMMA expression RPAR { Prim("min", $3, $5) }
  | MAX LPAR expression COMMA expression RPAR { Prim("max", $3, $5) }
;

%%
