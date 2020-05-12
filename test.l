%option noyywrap

%{
#include<stdio.h>
%}

%%
abc/de { printf("右上下文相关，匹配到了abc. yytext=%s, yyleng=%d\n",yytext, yyleng); }
de     { printf("匹配到了de\n"); }
%%

int main(){
  yylex();
  return 0;
}