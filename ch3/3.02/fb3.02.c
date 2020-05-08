#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "fb3.02.h"

int yyparse(void);

/* 为操作符，创建一个子树 */
struct ast *newast(int nodetype, struct ast *lft, struct ast *rht) {
  struct ast *a = malloc(sizeof(struct ast));
  if (!a) {
    yyerror("out of memory!");
    exit(0);
  }
  a->nodetype = nodetype;
  a->lft = lft;
  a->rht = rht;
  return a;
}

/* 为一个值，创建一个叶子节点 */
struct ast *newnum(double d) {
  struct numval *a = malloc(sizeof(struct numval));
  if (!a) {
    yyerror("out of memory!");
    exit(0);
  }
  a->nodetype = NT_NUM;
  a->number = d;

  // 此处将"struct numval"的类型强制转换为"struct ast"类型，是因为能够统一适配eval函数的入参类型；
  // 而eval函数能够正确运行得益于"struct numval"类型和"struct ast"类型中nodetype字段在内存中的相对位置是一致的。
  // 通过nodetype字段识别到"struct numval"类型的实例时，要使用该实例需要强制转换回来才行。
  return (struct ast *) a;
}

/* 递归计算各个子树的值 */
double eval(struct ast *a) {
  double v = 0; // result of eval

  switch (a->nodetype) {
    case NT_NUM:
      v = ((struct numval *) a)->number;
      break;
    case NT_ADD:
      v = eval(a->lft) + eval(a->rht);
      break;
    case NT_SUB:
      v = eval(a->lft) - eval(a->rht);
      break;
    case NT_MUL:
      v = eval(a->lft) * eval(a->rht);
      break;
    case NT_DIV:
      v = eval(a->lft) / eval(a->rht);
      break;
    case NT_ABS:
      v = eval(a->lft);
      v = v < 0 ? v * -1.0f : v;
      break;
    case NT_NEG: // 处理负数求值
      v = eval(a->lft) * -1.0f;
      break;

    default:
      printf("internal error:bad nodetype=%c,%d\n",
             a->nodetype, a->nodetype);
      break;
  }
  return v;
}

/* 递归释放各个树节点 */
void treefree(struct ast *a) {
  switch (a->nodetype) {
    case NT_ADD:/* 2颗子树 */
    case NT_SUB:
    case NT_MUL:
    case NT_DIV:
      treefree(a->lft);
      treefree(a->rht);
      break;
    case NT_ABS: /* 1颗子树 */
    case NT_NEG:
      treefree(a->lft);
      break;
    case NT_NUM:/* 没有子树 */
      free(a);
      a = NULL;
      break;
    default:
      printf("internal error:bad nodetype=%c,%d\n",
             a->nodetype, a->nodetype);
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