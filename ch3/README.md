# CH3 内容概览

### 3.01 bison基本概念及语法介绍

正式开始写bison代码之前，我想应该对bison是如何做语法分析有一定的了解。接下来我们将从`移进/规约分析`的相关概念开始

-   **移进/规约分析**，当语法分析器读取记号时，每当它读到的记号无法结束一条规则时，它将把这个记号压人一个内部堆栈，然后切换到一个新状态，这个状态能够反映出刚刚读取的记号，这种行为叫做移进（shift）。当它发现压入的所有语法符号已经可以组成规则的右部时，它将把右部符号全部从堆栈中弹出，然后把左部语法符号压入堆栈，这种行为叫做规约（reduction）。**[没有事先储备编译原理知识的同学请进，这里有中科大老师给你讲](https://www.bilibili.com/video/BV17W41187gL?p=27)**。

    每当bison规约一条规则时，它会执行该规则关联的动作代码，该代码也就是你对语法分析器分析的内容实际要做的事情。

-   **bison的两种语法分析方法**，一种是LALR(1)，自左向右前看一个记号；另一种是GLR，通用的自左向右。大多数语法分析器使用LALR(1)，它不如GLR强大但被认为比GLR更块和更容易使用。

    虽然LALR分析强大，但它对于语法规则有比较多的限制。它不能处理有歧义的语法，比如相同的输入可以匹配多棵语法分析树的二义性文法的情况（但是bison有一个很奇妙的技巧来解决常见的二义性文法）。它也不能处理需要向前看多个记号才能确定匹配规则的语法，下面有个实例：

    ```
    phrase: cart_animal AND CART
    	  | work_animal AND PLOW
    
    cart_animal: HORSE | GOAT
    
    work_animal: HORSE | OX
    ```

    这个语法并没有歧义，因为对于任何有效输入它只有一种可能跟的语法分析树，但bison无法处理它，因为它需要向前查看两个符号。具体来说，对于HORSE AND CART这种输入，在看到CART之前它无法区别HORSE是一个cart_animal还是一个work_animal，而bison不能前看这么多个符号。如果把第一条规则修改为：

    ```
    phrase: cart_animal CART
    	  | work_animal PLOW
    ```

    则bison将没有任何问题。bison知道哪些语法它可以分析，如果你给它一个不能分析的语法，它会告诉你并打印相应的报错信息。

-   **bison的基本规则**

    bison程序文件包含四个主要部分，如下：

    ```c
    
    /* 第一部分，此部分是bison声明部分，描述了使用的符号，语义值的数据类型，开始符号等。*/
    %start calclist /* 指定起始符号（start symbol）有时也称为目标符号（goal symbol） */
    %token NUMBER /* 声明tokens记号，以便于告诉bison在语法分析程序中记号的名称。通常这些记号总是使用大写字母，虽然bison本身并没有这个要求。 */
        
    %{
      /* 第二部分，其定义和声明的内容与Flex规定的类似。这部分包括，在第三部分语法规则中使用的宏定义，及函数和变量的声明。该部分的内容将直接复制到生成的代码文件的开头，以便它们在使用yyparse定义之前使用。 */
      #define _GNU_SOURCE
      #include <stdio.h>
      #include "ptypes.h"
    %}
    
    %%
    /* 第三部分，主要是语法规则 */
    calclist: /* 空规则 -- 起始符号（start symbol）有时也称为目标符号（goal symbol） */
      | calclist exp EOL { printf("- %d\n", $2); } // EOL 代表一个表达式的结束。像flex一样，大括号中的表示规则的动作
      ;
    
    exp: factor // default $$ = $1
      | exp ADD factor { $$ = $1 + $3; }
      | exp SUB factor { $$ = $1 - $3; }
      ; // represent the termination of this rule.
    
    factor: term // default $$ = $1
      | factor MUL term { $$ = $1 * $3; }
      | factor DIV term { $$ = $1 / $3; }
      ;
    
    term: NUMBER // default $$ = $1
      | ABS term { $$ = $2 >= 0? $2 : - $2; }
      ;
    %%
    /* 第四部分，此部分的内容将直接逐字复制到生成的代码文件末尾。该部分主要用于对之前一些声明了的函数进行实现。 */
    ```

    关于第一部分，bison可以在该部分声明的所有内容，[请查看](http://www.gnu.org/software/bison/manual/bison.html#Declarations)。

    关于第二部分，使用的时候经常会觉得不够灵活，作为替代方案，bison提供了`%code{code}`用于表示代码的用途以及生成代码的位置。此处不再对它进行详解，[欲知详情请看](http://www.gnu.org/software/bison/manual/bison.html#g_t_0025code-Summary)。

    bison通过把每个部分插入到标准的框架文件中来创建输出文件。语法规则会被编译生成数组的形式，数组的内容代表了可以匹配输入记号流的状态机。语义动作中的`$N`和`@N`的值会首先翻译成C代码，然后被放置到yyparse()中的switch语句中，yyparse()会在规约发生时执行相应的动作。框架文件中存在着一些不同版本的代码，bison将基于当前使用的选项来决定哪个版本被使用。

-   

### 3.02 使用bison在语法分析中构建抽象语法树AST

在编译器中最强大的数据结构之一就是抽象语法树（Abstract Syntax Tree， AST）。抽象语法树实在语法树的基础上去掉不需要关注的节点信息而形成的。语法分析器创建AST后，就可以通过对树的遍历进行更多的分析和计算。





