/* file: 3.02_create_AST_with_bison.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include "fb3.02.h"
%}

/* %union关键字声明了语法规则中所有语法值可能会用到的数据类型的一个集合 */
%union {
  struct ast *a;
  double d;
}

%token <d> NUMBER /* 声明记号，而"<d>"指定了该记号的数据类型 */
%token EOL

/* 当使用了union声明了一组数据类型集合后，你必须为所有的非终结符指定其值类型。使用"%type"关键字*/
%type <a> exp factor term

%start calclist /* 指定起始符号（start symbol）有时也称为目标符号（goal symbol） */

%%
calclist: /* -- 空规则，起始符号必须具备一个空规则，旨在让起始符号必须匹配整个输入 -- */
        | calclist exp EOL { printf("= %4.4g\n", eval($2)); treefree($2); printf("> "); }
        | calclist EOL { printf("> "); } /* 空行或注释 */
        ;

exp: factor
   | exp '+' factor { $$ = newast(NT_ADD, $1, $3); }
   | exp '-' factor { $$ = newast(NT_SUB, $1, $3); }
   ;

factor: term
      | factor '*' term { $$ = newast(NT_MUL, $1, $3); }
      | factor '/' term { $$ = newast(NT_DIV, $1, $3); }
      ;

term: NUMBER { $$ = newnum($1); }
    | '|' exp '|' { $$ = newast(NT_ABS, $2, NULL); }     // 使用绝对值符号的语法规则
    | '(' exp ')' { $$ = $2; }                           // 使用圆括号的语法规则
    | '-' term    { $$ = newast(NT_NEG, $2, NULL); }     // 使用负号的规则
    ;
%%
