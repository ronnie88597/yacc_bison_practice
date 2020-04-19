%%
"colour"        { printf("color");      } // 当匹配到了colour单词，将打印处color
"flavour"       { printf("flavor");     } // 当匹配到了flavour单词，将打印处flavor
"clever"        { printf("smart");      } // 当匹配到了clever单词，将打印处smart
"smart"         { printf("elegant");    } // 当匹配到了smart单词，将打印处elegant
"conservative"  { printf("liberal");    } // 当匹配到了conservative单词，将打印处liberal
"."             { printf("%s", yytext); } // 当匹配到其他任意字符，将原样输出
%%