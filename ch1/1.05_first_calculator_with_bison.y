/*
123
*/

%{
#include <stdio.h>
%}

/* declare tokens */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL

%%
calclist: /* empty rule -- start symbol */                         // Start to match from head of file
  | calclist exp EOL { printf("- %d\n", $2); }     // EOL represent the temination of an expression
  ;

exp: factor default $$ = $1
  | exp ADD factor { $$ = $1 + $3; }
  | exp SUB factor { $$ = $1 - $3; }
  ; // represent the termination of this rule.

factor: term default { $$ = $1; }
  | factor MUL term { $$ = $1 * $3; }
  | factor DIV term { $$ = $1 / $3; }
  ;

term: NUMBER default { $$ = $1; }
  | ABS term { $$ = $2 >= 0? $2 : - $2; }
  ;
%%
main(int argc, char **argv)
{
yyparse();
}
yyerror(char *s)
{
fprintf(stderr, "error: %s\n", s);
}