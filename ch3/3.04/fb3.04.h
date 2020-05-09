
/* 计算器声明部分 */
/**/



/* 与词法分析器的接口 */
extern int yylineno; /* 词法分析器已经定义 */
void yyerror(char *s, ...);



/* 符号表 */
struct symbol { /* 变量名 */
  char *name;
  double value;
  struct ast *func; /* 函数体 */
  struct symlist *syms; /* 虚拟参数列表 */
};


/* 固定大小的简单的符号表 */
#define NHASH 9997
struct symbol symtab[NHASH];

struct symbol *lookup(char*);

/* 符号列表，作为参数列表 */
struct symlist{
  struct symbol *sym;
  struct symlist *next;
};

struct symlist *newsymlist(struct symbol *sym, struct symlist *next);
void symlistfree(struct symlist *sl);


/* 内置函数 */
enum bift{
  B_sqrt = 1,
  B_exp,
  B_log,
  B_print
};


/* 节点类型 */
  // + - * / |
  // 0-7比较操作符，位编码： 04 等于， 02小于， 01 大于
  // M 单目符号
  // L 表达式或者语句列表
  // I IF语句
  // W WHILE语句
  // N 符号引用
  // = 赋值
  // S 符号列表
  // F 内置函数调用
  // C 用户函数调用


/* 抽象语法树节点 */
struct ast{
  int nodetype;
  struct ast *lft;
  struct ast *rht;
};

/* 内置函数 */
struct fncall {
  int nodetype;
  struct ast *lft;
  enum bifs functype;
};

/* 用户自定义函数 */
struct ufncall {
  int nodetype;
  struct ast *lft;
  struct symbol *s;
};

struct flow{
  int nodetype;
  struct ast *code;
  struct ast *tl;
  struct ast *el;
};

struct numval{
  int nodetype;
  double number;
};

struct symref{
  int nodetype;
  struct symbol *s;
};

struct symasgn{
  int nodetype;
  struct symbol *s;
  struct ast *v;
};



/* 构造抽象语法树 */
struct ast *newast(int nodetype, struct ast *lft, struct ast *rht);
struct ast *newcmp(int cmptype, struct ast *lft, struct ast *rht);
struct ast *newfunc(int functype, struct ast *lft);
struct ast *newcall(struct symbol *s, struct ast *l);
struct ast *newref(struct symbol *s);
struct ast *newasgn(struct symbol *s, struct ast *v);
struct ast *newnum(double d);
struct ast *newflow(int nodetype, struct ast *cond, struct ast *tl, struct ast *tr);


/* 定义函数 */
void dodef(struct symbol *name, struct symlist *syms, struct ast *stmts);

/* 计算抽象语法树 */
double eval(struct ast *);

/* 删除和释放抽象语法树 */
void treefree(struct ast *);

/* 与词法分析器的接口 */
extern int yylineno; /* 来自词法分析器 */
void yyerror(char *s, ...);
