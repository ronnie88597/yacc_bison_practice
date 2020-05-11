#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "fb3.02.h"

int yyparse(void);

/* 为操作符，创建一个子树 */
struct ASTNode *newast(int NodeType, struct ASTNode *Lft, struct ASTNode *Rht) {
  struct ASTNode *a = malloc(sizeof(struct ASTNode));
  if (!a) {
    yyerror("out of memory!");
    exit(0);
  }
  a->NodeType = NodeType;
  a->Lft = Lft;
  a->Rht = Rht;
  return a;
}

/* 为一个值，创建一个叶子节点 */
struct ASTNode *newnum(double d) {
  struct numval *a = malloc(sizeof(struct numval));
  if (!a) {
    yyerror("out of memory!");
    exit(0);
  }
  a->NodeType = NT_NUM;
  a->number = d;

  // 此处将"struct numval"的类型强制转换为"struct ASTNode"类型，是因为能够统一适配eval函数的入参类型；
  // 而eval函数能够正确运行得益于"struct numval"类型和"struct ASTNode"类型中nodetype字段在内存中的相对位置是一致的。
  // 通过nodetype字段识别到"struct numval"类型的实例时，要使用该实例需要强制转换回来才行。
  return (struct ASTNode *) a;
}

/* 递归计算各个子树的值 */
double eval(struct ASTNode *a) {
  double v = 0; // result of eval

  switch (a->NodeType) {
    case NT_NUM:
      v = ((struct numval *) a)->number;
      break;
    case NT_ADD:
      v = eval(a->Lft) + eval(a->Rht);
      break;
    case NT_SUB:
      v = eval(a->Lft) - eval(a->Rht);
      break;
    case NT_MUL:
      v = eval(a->Lft) * eval(a->Rht);
      break;
    case NT_DIV:
      v = eval(a->Lft) / eval(a->Rht);
      break;
    case NT_ABS:
      v = eval(a->Lft);
      v = v < 0 ? v * -1.0f : v;
      break;
    case NT_NEG: // 处理负数求值
      v = eval(a->Lft) * -1.0f;
      break;

    default:
      printf("internal error:bad NodeType=%c,%d\n",
             a->NodeType, a->NodeType);
      break;
  }
  return v;
}

/* 递归释放各个树节点 */
void treefree(struct ASTNode *a) {
  switch (a->NodeType) {
    case NT_ADD:/* 2颗子树 */
    case NT_SUB:
    case NT_MUL:
    case NT_DIV:
      treefree(a->Lft);
      treefree(a->Rht);
      break;
    case NT_ABS: /* 1颗子树 */
    case NT_NEG:
      treefree(a->Lft);
      break;
    case NT_NUM:/* 没有子树 */
      free(a);
      a = NULL;
      break;
    default:
      printf("internal error:bad NodeType=%c,%d\n",
             a->NodeType, a->NodeType);
      break;
  }
}

void yyerror(char *s, ...) {
  va_list ap;
  va_start(ap, s);
  fprintf(stderr, "%d: error: ", yylineno);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}

int main(int argc, char **argv) {
  printf("> ");
  return yyparse();
}