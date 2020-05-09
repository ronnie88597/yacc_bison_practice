/* 语法分析器 */

/* 基于抽象语法树的计算器 */

%{
#include <stdio.h>
#include <stdlib.h>
#include "fb3.04.h"
%}


%union{
struct ast *a;
double d;
struct symbol *s;
struct symlist *sl;
int fn;
}

/* 声明记号 */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL

%token IF THEN ELSE WHILE DO LET

%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS

%type <a> exp stmt list explist

%type <sl> symlist

%start calclist


%%

/* 顶层的语法规则 */
calclist: /* 空规则 */
        | calclist stmt EOL {
          printf("= %4.4g\n> ",eval($2));
          treefree($2);
        }
        | calclist LET NAME '(' symlist ')' '=' list EOL {
          dodef($3, $5, $8);
          printf("Defined %s\n> ", $3->name);
        }
        | calclist error EOL { yyerrok; printf("> "); }

/* 控制流的语法 */
stmt: IF exp THEN list { $$ = newflow('I', $2, $4, NULL); }
    | IF exp THEN list ELSE list { $$ = newflow('I', $2, $4, $6); }
    | WHILE exp DO list { $$ = newflow('W', $2, $4, NULL); }
    | exp
    ;

list: /* 空规则 */ { $$ = NULL; }
    | stmt ';' list {if ($3 == NULL){
                      $$ = $1;
                     }else{
                      $$ = newast('L', $1, $3);
                     }}
    ;

/* 计算表达式的语法 */
exp: exp CMP exp { $$ = newcmp($2, $1, $3); }
   | exp '+' exp { $$ = newast('+', $1, $3); }
   | exp '-' exp { $$ = newast('-', $1, $3); }
   | exp '*' exp { $$ = newast('*', $1, $3); }
   | exp '/' exp { $$ = newast('/', $1, $3); }
   | '|' exp     { $$ = newast('|', $2, NULL); }
   | '(' exp ')' { $$ = $2; }
   | '-' exp %prec UMINUS   { $$ = newast('M', $2, NULL); }
   | NUMBER { $$ = newnum($1); }
   | NAME   { $$ = newref($1); }
   | NAME '=' exp { $$ = newasgn($1,$3); }
   | FUNC '(' explist ')' { $$ = newfunc($1, $3); }
   | NAME '(' explist ')' { $$ = newcall($1, $3); }
   ;

explist: exp
       | exp ',' explist { $$ = newast('L', $1, $3); }
       ;

symlist: NAME { $$ = newsymlist($1, NULL); }
       | NAME ',' symlist { $$ = newsymlist($1, $3); }
       ;
%%
