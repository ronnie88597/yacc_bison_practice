/*
// file: 2.03_read_files.y
// 使用flex读取多个文件作为输入
//
// */

%option noyywrap
%{
int chars = 0;
int words = 0;
int lines = 0;

int totchars = 0;
int totwords = 0;
int totlines = 0;
%}

%%
[a-zA-Z]+         { words++; chars += strlen(yytext); }
\n                { chars++; lines++; }
.                 { chars++; }
%%

#define HEADLINE    "file                chars   words   lines   \n"
#define STREAMLINE  "%-20s%-8d%-8d%-8d\n"

int main(int argc, char ** argv)
{
  int i;
  if ( argc < 2 ){ /* 读取标准输入 */
    yylex();
    printf(HEADLINE);
    printf(STREAMLINE, "STDIN", chars, words, lines);
    return 0;
  }
  printf(HEADLINE);
  for(i = 1; i < argc; i++){
    FILE *f = fopen(argv[i], "r");
    if (!f){
      perror(argv[i]);
      return 1;
    }

    yyrestart(f);
    yylex();
    fclose(f);
    printf(STREAMLINE, argv[i], chars, words, lines);
    totchars += chars; chars = 0;
    totwords += words; words = 0;
    totlines += lines; lines = 0;
  }
  printf("\nTotal:\n");
  printf("chars   words   lines   \n");
  printf("%-8d%-8d%-8d\n", totchars, totwords, totlines);
  return 0;
}