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
  a->nodetype = 'K';
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
    case 'K':
      v = ((struct numval *) a)->number;
      break;
    case '+':
      v = eval(a->lft) + eval(a->rht);
      break;
    case '-':
      v = eval(a->lft) - eval(a->rht);
      break;
    case '*':
      v = eval(a->lft) * eval(a->rht);
      break;
    case '/':
      v = eval(a->lft) / eval(a->rht);
      break;
    case '|':
      v = eval(a->lft);
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
    case '+':/* 2颗子树 */
    case '-':
    case '*':
    case '/':
      treefree(a->lft);
      treefree(a->rht);
      break;
    case '|': /* 1颗子树 */
      treefree(a->rht);
      break;
    case 'K':/* 没有子树 */
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