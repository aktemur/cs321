%{


%}

%token <int> INTEGER
%token <string> NAME
%token EOF
%token PLUS STAR MINUS SLASH

/* Precedence definitions: */
/* lowest precedence  */

/* highest precedence  */

%start expression
%type <expr> expression

%%

expression:
    INTEGER                            { CstI $1 }
  | NAME                               { Var $1  }
;

%%
