/* 计算器的声明部分 */

/* 与词法分析器的接口 */
extern int yylineno;

void yyerror(char *s, ...);

enum NodeT { // 声明所有语法树节点类型的枚举值
  NT_UNDEF,
  NT_ADD,
  NT_SUB,
  NT_MUL,
  NT_DIV,
  NT_ABS,
  NT_NEG,
  NT_NUM,
};

/* 抽象语法树中的节点 */
struct ast {
  int nodetype;
  struct ast *lft;
  struct ast *rht;
};

struct numval {
  int nodetype; /* 类型K 表明常量 */
  double number;
};

/* 构造抽象语法树 */
struct ast *newast(int nodetype, struct ast *lft, struct ast *rht);

struct ast *newnum(double d);

/* 计算抽象语法树 */
double eval(struct ast *);

/* 删除和释放抽象语法树 */
void treefree(struct ast *);

