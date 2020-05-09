/* 不使用-lfl定义的默认main函数，使用自定义的main函数，你就不需要链接-lfl了。 */
%option noyywrap

%{
#include "fb3.02.h"
#include "3.02_create_AST_with_bison.tab.h"
%}

/* 此处声明模式的公共部分，用于简化匹配模式的书写。*/
/* 浮点数指数部分 */
EXP ([Ee][-+]?[0-9]+)

%%
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" { return yytext[0]; }

[0-9]+"."[0-9]*{EXP}?|"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }

\n          { return EOL; }
"//".*\n
[ \t]       { /* 忽略空白字符 */}
.           { yyerror("Mystery character %c\n", *yytext); }
%%