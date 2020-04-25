/*
使用Flex和Bison手写词法分析器和语法分析器，实现一个简单的计算器
这是语法解析器部分
*/

%{
#include <stdio.h>
%}

/* 声明tokens记号，以便于告诉bison在语法分析程序中记号的名称。
// 通常这些记号总是使用大写字母，虽然bison本身并没有这个要求。 */
%token NUMBER
%token ADD SUB MUL DIV ABS
%token L_PARENTHESIS R_PARENTHESIS
%token EOL

%start calclist /* 指定起始符号（start symbol）有时也称为目标符号（goal symbol） */

// 没有任何声明的记号的语法符号必须规则的左边出现至少一次。
// 如果一个语法符号既不是声明过的记号，也没有出现在任何规则的左边，
// 它将导致出现一个未声明的错误。
%%
exp:
calclist: /* -- 空规则，起始符号必须具备一个空规则，旨在让起始符号必须匹配整个输入 -- */
        | calclist exp EOL { printf("= %d\n", $2); } // EOL 代表一个表达式的结束。像flex一样，大括号中的表示规则的动作
        ;

exp: exp ADD factor { $$ = $1 + $3; }             // 加法语法规则
   | exp SUB factor { $$ = $1 - $3; }             // 减法语法规则
   | factor
   ; // represent the termination of this rule.

factor: factor MUL term { $$ = $1 * $3; }         // 乘法语法规则
      | factor DIV term { $$ = $1 / $3; }         // 除法语法规则
      | term
      ;

term: NUMBER
    | ABS exp ABS { $$ = $2 >= 0? $2 : - $2; }     // 增加使用绝对值符号的语法规则
    | L_PARENTHESIS exp R_PARENTHESIS { $$ = $2; } // 增加使用圆括号的语法规则
    ;
%%
int main(int argc, char **argv)
{
  // yyparse是语法解析函数，调用yyparse将开始语法解析。
  // 该函数读取tokens并语法规则匹配，匹配成功后，执行相应的动作，直到文件的读取结束或者发生不可恢复的错误函数将返回。
  // 此外，你也可以在action中使yyparse直接提前返回。
  yyparse();
	return 0;
}
yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
}