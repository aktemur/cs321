%{


%}

%token <int> INTEGER
%token <string> NAME
%token EOF
%token PLUS STAR MINUS SLASH
%token LET EQ IN

/* Precedence definitions: */
/* lowest precedence  */
%nonassoc IN
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
  | expression PLUS expression         { Plus($1, $3)  }
  | expression STAR expression         { Star($1, $3)  }
  | expression MINUS expression        { Minus($1, $3) }
  | expression SLASH expression        { Slash($1, $3) }
  | LET NAME EQ expression IN expression { Let($2, $4, $6) }
;

%%
