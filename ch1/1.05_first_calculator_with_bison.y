/*
利用Bison实现四则运算的语法解析器
*/

%{
#include <stdio.h>
%}

/* 声明tokens记号，以便于告诉bison在语法分析程序中记号的名称。
// 通常这些记号总是使用大写字母，虽然bison本身并没有这个要求。 */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token EOL


// 没有任何声明的记号的语法符号必须规则的左边出现至少一次。
// 如果一个语法符号既不是声明过的记号，也没有出现在任何规则的左边，
// 它将导致出现一个未声明的错误。
%%
calclist: /* 空规则 -- 起始符号（start symbol）有时也称为目标符号（goal symbol） */
  | calclist exp EOL { printf("- %d\n", $2); } // EOL 代表一个表达式的结束。像flex一样，大括号中的表示规则的动作
  ;

exp: factor // default $$ = $1
  | exp ADD factor { $$ = $1 + $3; }
  | exp SUB factor { $$ = $1 - $3; }
  ; // represent the termination of this rule.

factor: term // default $$ = $1
  | factor MUL term { $$ = $1 * $3; }
  | factor DIV term { $$ = $1 / $3; }
  ;

term: NUMBER // default $$ = $1
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