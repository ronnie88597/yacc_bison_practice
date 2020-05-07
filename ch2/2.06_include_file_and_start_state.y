/*
// file: 2.06_include_file_and_start_state.y
// 使用Flex处理嵌套的包含文件（include files）与起始条件
// 这个程序将处理嵌套包含文件，同时打印出这些文件中每一行的行号。
// 这个程序需要维护一个包含嵌套输入文件和行号的堆栈，在每次遇到一个`#include `时压栈当前文件和行号等信息，在处理完包含文件后再把它们从堆栈弹出。
// 此外本程序将使用flex一个很强大的特性——起始条件（start condition），它允许我们指定一个特定时刻哪些模式可以被用来匹配。
// */


/* 不使用-lfl定义的默认main函数，使用自定义的main函数，你就不需要链接-lfl了。 */
%option noyywrap

/* 把`IFILE`定义为起始条件，它将在我们寻找`#include`语句中的文件名时被使用。 */
%x IFILE

%{
struct buffstack {
  struct buffstack *prev; /* 上一个文件信息 */
  YY_BUFFER_STATE bufferstate; /* 保存的缓冲区 */
  int lineno; /* 保存的行号 */
  char *filename; /* 文件名 */
  FILE *f; /* 当前文件 */
} *curbstk = 0;

char *curfilename; /* 当前输入文件的名字 */
int newfile(char *fn);
int popfile(void);
%}

%%
^"#"[ \t]*include[ \t]*[\"<]   { // 匹配#include语句，直到双引号或者<
  BEGIN(IFILE); // 宏`BEGIN`用来切换到另外一个起始条件。
}

<IFILE>[^ \t\n\">]+ { // 匹配文件名，直到结束双引号、>或者换行符。 当模式紧随在<起始条件名字>之后(<IFILE>)，表示这个模式只在该起始条件激活时才进行匹配。
  { // 当文件名匹配到这个模式时，#include的语句还有剩下的部分没有处理。使用下面简单的循环读完它并忽略它
    int c;
    while((c=input()) && c != '\n');
  }
  yylineno++;
  if(!newfile(yytext)){
    yyterminate(); // Error: no such file, or other failure.
  }
  printf("[INFO]开始读取include文件:%10s作为输入.\n", curbstk->filename);
  BEGIN(INITIAL); // flex本身会定义的`INITIAL`起始条件
}

<IFILE>.|\n { //  处理IFILE起始条件中错误输入的情况
  fprintf(stderr, "行号：%8d 错误的include语法\n", yylineno);
  yyterminate();
}

<<EOF>> { // <<EOF>>是Flex定义的特殊模式，它匹配输入文件的结束。
  printf("[INFO]结束读取include文件:%10s.\n", curbstk->filename);
  if(!popfile()){ // 当文件结束时弹出文件堆栈，如果是最外层文件就结束
    yyterminate();
  }
}

^. { // 在每一行开始时，打印行号
  fprintf(yyout, "%8d %s", yylineno, yytext); // yylineno是Flex提供的记录行号的变量
}

^\n { // 每遇到一个\n，需要把行号+1
  fprintf(yyout, "%8d %s", yylineno++, yytext);
}

\n {
  ECHO;
  yylineno++;
}

. { // 这是Flex定义的默认的规则，其中ECHO是Flex定义的默认输出宏，它会将字符原样输出到yyout。关于ECHO详见2.05，https://blog.csdn.net/weixin_46222091/article/details/105968391
  ECHO;
}
%%
int main(int argc, char ** argv){
  if(argc < 2){
    fprintf(stderr, "need filename\n");
    return 1;
  }
  if(newfile(argv[1])) yylex();
}

int newfile(char *fn){
  FILE *f = fopen(fn, "r");
  struct buffstack *bstk = malloc(sizeof(struct buffstack));

  /* 如果文件打开失败时，退出 */
  if(!f) {
    perror(fn);
    return 0;
  }
  /* 如果没有足够空间时，退出 */
  if(!bstk){
    perror("malloc");
    exit(1);
  }

  /* 记住当前状态 */
  if(curbstk){
    curbstk->lineno = yylineno;
    bstk->prev = curbstk;
  }

  /* 建立当前文件信息 */
  bstk->bufferstate = yy_create_buffer(f, YY_BUF_SIZE);
  bstk->f = f;
  bstk->filename = fn;
  yy_switch_to_buffer(bstk->bufferstate);
  curbstk = bstk;
  yylineno = 1;
  curfilename = fn;
  return 1;
}

int popfile(void){
  struct buffstack *bstk = curbstk;
  struct buffstack *prevbstk;

  if(!bstk){
    return 0;
  }

  /* 删除当前文件信息 */
  fclose(bstk->f);
  yy_delete_buffer(bstk->bufferstate);

  /* 切换回上一个文件 */
  prevbstk = bstk->prev;
  free(bstk);

  if(!prevbstk){
    return 0;
  }

  yy_switch_to_buffer(prevbstk->bufferstate);
  curbstk=prevbstk;
  yylineno = curbstk->lineno;
  curfilename = curbstk->filename;
  return 1;
}