// 词法解析器部分
// 使用Flex和Bison手写词法分析器和语法分析器，实现一个简单的计算
%{
# include "1.05_first_calculator_with_bison.tab.h" // 此处需要将语法分析器生成的头文件包含进来，这样Flex和bison就可以联合工作了
%}

%%
"+"                     { return ADD; }
"-"                     { return SUB; }
"*"                     { return MUL; }
"/"                     { return DIV; }
"|"                     { return ABS; }
"("                     { return L_PARENTHESIS; }
")"                     { return R_PARENTHESIS; }

[-+]?[0-9]+             { yylval = atoi(yytext); return NUMBER; } // 识别整数
\n                      { return EOL; }
[ \t]                   { /*忽略空白字符*/ }
.                       { printf("Mystery character %c\n", *yytext); }
%%

