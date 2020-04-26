/*
// file: 2.02_use_yyin_to_read_data_from_file.y
// flex词法分析器默认从stdin读取输入
//
// 除非你对yyin另做安排，词法分析器总是通过yyin文件描述符读取输入，因此为了让flex从文件读取输入
// 你只需要在第一次调用yylex之前重新设定yyin文件描述符
// */

/*
// flex和lex总是提供了一个小型的库，叫做-lfl，它定义了默认的main例程，同时也定义了早期lex遗留至今的鸡肋——默认版本的yywrap
// flex的较新的版本允许你在词法分析器的开头设定%option noyywrap，来要求不使用yywrap
// lfl库中的main函数，如下：
// int main()
// {
//    while (yylex() != 0);
//    return 0;
// }
// 如果你在flex程序使用%option noyywrap，并且定义了自己的main函数，你就不需要链接-lfl了。
// */
%option noyywrap
%{
int chars = 0;
int words = 0;
int lines = 0;
%}

%%
[a-zA-Z]+         { words++; chars += strlen(yytext); }
\n                { chars++; lines++; }
.                 { chars++;}

%%

int main(int argc, char ** argv)
{
  if ( argc > 1 ) {
    if (! (yyin = fopen(argv[1], "r" ) )){
      perror(argv[1]);
      return 1;
    }
    printf("[I]>>>Read data from file:%s\n", argv[1]);
  }else{
    printf("[I]>>>Read data from stdin.\n");
  }
  yylex();
  printf("chars=%8d\n", chars );
  printf("words=%8d\n", words );
  printf("lines=%8d\n", lines );
  return 0;
}