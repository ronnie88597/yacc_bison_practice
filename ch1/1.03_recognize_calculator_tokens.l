/*
用于将输入的计算表达式识别为token流，然后输入
*/


/*
前5个匹配模式，使用了双引号，flex将使用引号内的文本而不会将其解释为正则表达式。
*/
%%
"+"         { printf("PLUS\n"); } // 当匹配上了+，将打印PLUS
"-"         { printf("MINUS\n"); }
"*"         { printf("TIMES\n"); }
"/"         { printf("DIVIDE\n"); }
"|"         { printf("ABS\n"); }
[0-9]+      { printf("NUMBER %s\n", yytext); } // yytext变量总是指向本次匹配的输入文本字符串
\n          { printf("NEWLINE\n"); }
[ \t]       {}
.           { printf("Mystery character %s\n", yytext); } // yytext变量总是指向本次匹配的输入文本字符串
%%