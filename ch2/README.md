# CH2 内容概览

### 2.01

Flex实现词法分析器时常见的用于定义匹配模式的RE汇总

### 2.02

flex词法分析器默认从stdin读取输入

### 2.03

使用flex读取多个文件作为输入

### 2.04 Flex词法分析器的IO结构及输入管理

大多数情况下，flex词法分析器从文件或STDIN（终端用户）中读取输入。从文件读取和从终端读取存在着一个微小但是重要的差异——预读机制。如果词法分析器从文件读取，它可以通过大段的读操作来提高工作效率。但是如果它从终端读取，用户可能一次只输入一行，并且期望每行输入完成时，词法分析器能够立刻处理。在这种情况下处理效率不再是一个问题。幸运的是，flex词法恩稀奇会检查当前输入是否来自终端并决定使用哪种读取方式。

flex处理输入的数据结构为yy_buffer_state，而YY_BUFFER_STATE是typedef定义的yy_buffer_state结构体的指针类型。

```c
#ifndef YY_TYPEDEF_YY_BUFFER_STATE
#define YY_TYPEDEF_YY_BUFFER_STATE
typedef struct yy_buffer_state *YY_BUFFER_STATE;
#endif
#ifndef YY_STRUCT_YY_BUFFER_STATE
#define YY_STRUCT_YY_BUFFER_STATE
struct yy_buffer_state
	{
	FILE *yy_input_file; /* 输入文件的句柄 */

	char *yy_ch_buf;		/* 输入缓冲区 */
	char *yy_buf_pos;		/* 在输入缓冲区中当前读取的位置 */

	/* 输入缓冲区的字节数，不包括终结符（EOB）字符。EOB为End of Block的缩写 */
	int yy_buf_size; 

	/* yy_ch_buf中已经读取了的字符数，不包括终结符（EOB）字符 */
	int yy_n_chars;

	/* 我们是否“拥有”缓冲区。也就是说，我们知道已经创建了缓冲区，并且可以重新分配以增长缓冲区，并应该适时释放缓冲区 */
	int yy_is_our_buffer;

	/* 是否是“交互性”的输入。如果是交互性输入或者以STDIN作为输入，用getc()函数代替fread()函数，使得每行结束后词法分析器可以立即处理 */
	int yy_is_interactive;

	/* 是否在行首。若是，则下次匹配时"^"规则将生效；若不是，反之 */
	int yy_at_bol;

    int yy_bs_lineno; /* 行号 */
    int yy_bs_column; /* 列号 */

	/* 在到达输入结束时，是否填充输入缓冲区 */
	int yy_fill_buffer;

    /* 缓冲区状态 */
	int yy_buffer_status;

#define YY_BUFFER_NEW 0 /* 当遇到EOF后，使用yyrestart()函数，可以将yy_buffer_status置为YY_BUFFER_NEW。这样允许用户可以重新指定下一个输入继续词法分析*/
#define YY_BUFFER_NORMAL 1 /* 一般正常情况下，yy_buffer_status是这个状态*/
#define YY_BUFFER_EOF_PENDING 2 /*当遇到了EOF但仍有一些文本要处理，yy_buffer_status置为YY_BUFFER_EOF_PENDING，以表明不应该再尝试从输入源读取数据了。但由于可能还有一些已经读取的输入还没有处理完，可能仍有许多token要匹配，直到所有为处理的字符被“耗尽”。*/
	};
#endif /* !YY_STRUCT_YY_BUFFER_STATE */
```

该结构定义了一个单一输入源。它包含一个字符串缓冲区，以及一些变量和标记。通常它会有一个指向所读文件的FILE*，但是我们也可以创建一个与文件无关的YY_BUFFER_STATE实例来分析已经在内存中的字符串。

默认的flex词法分析器的输入行为大致如下:

```c
YY_BUFFER_STATE bp;
extern FILE* yyin;

// ..... 省略，此处包含任何在第一次调用词法分析器之前所需要做的事情

if(!yyin){
	yyin = stdin; // 默认输入设备是stdin
}
bp = yy_create_buffer(yyin, YY_BUFFER_SIZE); // YY_BUFFER_SIZE由flex定义，大小通常是16k
yy_switch_to_buffer(bp); // 告诉它使用我们刚刚创建的缓冲区
```

如果yyin还没有被设置，就把stdin设置给它。然后使用yy_create_buffer函数创建一个读取yyin的新缓冲区，通过yy_switch_to_buffer函数来将新缓冲区切换为当前读取的输入，以便于词法分析器从最新的缓冲区读取开始分析。

当需要顺序读取多个文件时，每次打开一个文件需要调用一次yyrestart(fp)函数，把词法分析器的输入切换到输入文件fp。

其他一些函数也可以用来创建缓冲区，包括yy_scan_string("This is a string.")用于分析以空字符'\0'结尾的字符串，和yy_scan_buffer(char *base, size)分析长度确定的数据流。

flex提供了两个动作代码中比较有用的宏，input()和unput()。每次input()的调用将返回输入流的下一个字符。它可以帮助我们读取一小段输入而不用定义相应的模式。每次对unput(c)的调用把字符c推回到输入流。这个功能可以向前查看输入但不做处理。

总结以下，输入管理的三个层次是：

-   设置yyin来读取所需文件
-   创建并使用YY_BUFFER_STATE输入缓冲区
-   重定义YY_INPUT

### 2.05 Flex词法分析器的输出管理

词法分析器的输出管理比输入管理简单得多，而且完全可选的。同样可以追溯到最早的lex版本，除非你另行设定，否则flex总会执行一条默认的规则：所有没有被匹配的输入都拷贝yyout然后输出。

```c
%{
/* ...省略部分 */
#define ECHO fwrite(yytext, yyleng, 1, yyout)
%}

%%
/* ...省略部分 */
. ECHO; // flex默认的规则：所有没有被匹配的输入都拷贝yyout然后输出
%%
    
// 注意：由于目前还没有学到起始条件（start condition）相关的知识，以上flex默认的规则只是一个简版，实际上它应该为：<*>.|\n     ECHO;
```

**注意**：这对于那些仅处理一部分输入而保持剩余部分不变的flex程序来说可能有些作用，比如在英式英语转换到美式英语的翻译器中，但大多数情况下它更容易导致一些错误。flex允许你在词法分析器顶端设置`%option nodefault`，使它不要添加默认的规则，这样当输入无法被给定的规则完全匹配时，词法分析器可以报告一个错误。

**建议词法分析器总是使用nodefault选项，并在必要情况下包含自己的默认规则。**

### 2.06 使用Flex处理嵌套的包含文件（include files）与起始条件（start condition）

这个程序将处理嵌套包含文件，同时打印出这些文件中每一行的行号。这个程序需要维护一个包含嵌套输入文件和行号的堆栈，在每次遇到一个`#include `时压栈当前文件和行号等信息，在处理完包含文件后再把它们从堆栈弹出。

此外本程序将使用flex一个很强大的特性——起始条件（start condition），它允许我们指定一个特定时刻哪些模式可以被用来匹配。

###### 起始条件定义：

1.  起始条件需要在第一部分中声明；

2.  **声明语句的行首不能有空白符**；

3.  格式为：`%x CONDNAME1`或者`%s CONDNAME2`

    `%x`表示将CONDNAME1声明为一个独占（exclusive）的起始条件。意味着该条件被激活时，只有该状态的模式才可以进行匹配。

    `%s`表示将CONDNAME2声明为一个包含（inclusive）的起始条件，它允许未标记为任何条件的模式也可以进行匹配。

###### 起始条件的使用

```c
// 这是Flex的第一部分
%x CONDNAME1
%s CONDNAME2

// 这是Flex的第二部分
%{
#include <stdio.h>
%}

// 这是Flex的第三部分
%%
\" {
	BEGIN(CONDNAME1); // 激活CONDNAME1条件，起始条件周围的圆括号是可选的
}

<CONDNAME1>[^"]*	{ // 仅在CONDNAME1条件激活时，才会使用该模式
	/* eat up the string body ... */
	...
}

"<" {
	BEGIN(CONDNAME2); // 激活CONDNAME2条件，且停止CONDNAME1条件的激活
}

<CONDNAME2>[^>]*	{ // 仅在CONDNAME2条件激活时，才会使用该模式
	/* eat up the string body ... */
	...
}

<INITIAL,CONDNAME1,QUOTE>\.  {  // 仅在INITIAL或CONDNAME1或QUOTE条件激活时，才会使用该模式
	/* handle an escape ... */
    ...
}
            
<*>.|\n     ECHO; // <*> 将匹配任意的起始条件，所以无论在什么情况下，该条规则总能够用于匹配。实际上这是Flex的默认定义的一条规则
%%
// 这是Flex的第四部分
```

BEGIN动作也可以在规则开头部分的以缩进开头，例如：

```c
%x SPECIAL

%{
int enter_special;
%}

%%
        if ( enter_special ){ // 每当调用yylex()函数且enter_special不为0时，将立刻激活SPECIAL起始条件
            BEGIN(SPECIAL);
        }
%%
```

**注意**：词法分析器从起始条件0开始，也被称为INITIAL起始条件。BEGIN(INITIAL)等效于 BEGIN(0)

### 2.07 Flex如何处理上下文相关性

flex提供了多种方式来做到模式的左上下文相关和有上下文相关，也就是与记号的上文和下文相关。

#### 左上下文相关

有三种方法可以做到左上下文相关：

1.  **特殊的行首模式字符**

    在模式开头的字符'^'可以让flex只在行首匹配该模式。'^'本身并不匹配任何字符，它只用于指定上下文。

2.  **起始条件**

    ```c
    %s MYSTATE
    %%
    first { BEGIN(MYSTATE); }
    ...
    <MYSTATE>second { BEGIN(INITIAL); }
    %%
    ```

    在这个例子中second记号只在first记号出现之后才被匹配。而且这两个记号之间也允许存在其他插入的记号。关于[点击查看起始条件更多的信息](https://blog.csdn.net/weixin_46222091/article/details/105975522)

3.  **显示代码**

    你也可以通过设定标志的方法来伪造左上下文相关性，这个标志可以用来从一个记号传递上下文信息到另外一个单词。

    ```c
    %{
    int flag = 0;
    %}
    %%
    a { flag = 1; }
    b { flag = 2; }
    zzz {
    	switch(flag){
    	case 1: a_zzz_token();break;
    	case 2: b_zzz_token();break;
    	default: plain_zzz_token();break;
    	}
    	flag = 0;
    }
    %%
    ```



#### 右上下文相关

同样也有三种方法来使记号的识别依赖于该记号的右边文字：

1.  **特殊的行尾模式字符**

    在模式末尾的字符'\$'使得该模式尽在行尾得到匹配。和'^'字符一样'\$'字符不匹配任何字符，它仅仅指定上下文。'\$'等价于/\n。

2.  **斜线操作符**

    模式中的字符'/'让你可以包含显示尾部上下文。距离来说，模式abc/de可以匹配记号abc，但仅仅在后面紧跟着de的情况下。/自身不匹配任何字符。flex在决定多个模式中哪个具有最长匹配时会计算尾部上下文字符的个数，但是这些字符不会出现在yytext里，也不会被计算在yyleng中。举个实际的例子：

    ```c
    /* 词法分析器 */
    %option noyywrap
    
    %{
    #include<stdio.h>
    %}
    
    %%
    abc/de { printf("右上下文相关，匹配到了abc\n"); }
    de     { printf("匹配到了de\n"); }
    %%
    
    int main(){
      yylex();
      return 0;
    }
    ```

    编译后运行的结果：

    ```
    cmp@t3600:~/work_dir/source_code/yacc_bison_practice/cmake-build-debug$ ./test 
    abcd
    abcd
    abcde
    右上下文相关，匹配到了abc. yytext=abc, yyleng=3
    匹配到了de
    ```

    从上面的结果中可以看出，直接输出abc，并不会匹配到自定义模式中。当输入abcde时，首先匹配到了abc/de模式，识别到了abc字符，此时并不会消耗字符de。接下来会继续匹配到第二个模式，识别到了de字符。

3.  **yyless()**

    yyless()染个flex推回到刚刚读到的记号。yyless()的参数表明需要保留的字符个数，例如，将上面例子中的两个模式换成下面的一个模式

    ```c
    abcde { yyless(3);printf("右上下文相关，匹配到了abc\n"); }
    ```

    编译后运行的结果如下：

    ```
    cmp@t3600:~/work_dir/source_code/yacc_bison_practice/cmake-build-debug$ ./test 
    abc
    abc
    abcde
    右上下文相关，匹配到了abc. yytext=abc, yyleng=3
    de
    ```

    与斜线操作类似，当输入abcde时，首先匹配到了abc/de模式，识别到了abc字符，此时并不会消耗字符de。



### 2.08 Flex如何为部分通用匹配模式定义一个名字

为部分通用匹配模式定义一个名字可以帮助我们分解复杂的表达式，并有助于表达出你的设计意图。

定义采用的格式：

```c
NAME RE_Expr
```

名字可以包含字母、数字、连字符和下划线，但不能以数字开头。

在规则部分，模式可能会包含通过花括号{}括起的基于名字的替换，例如{NAME}。这个名字所代表的表达式将被代入到模式中，**并且该表达式会被认为已经用圆括号括起来了**，例如：

```c
DIG [0-9]
...
%%
{DIG}+ { process_integer(); }
{DIG}+\.{DIG}* |
\.{DIG}+ { process_real(); }
%%
```



### 2.09 Flex单个程序中的多重词法分析器

你可能希望在同一个程序中使用两个部分或者完全不同的记号语法。一个交互式调试解释器可能需要一个词法分析器用于编程语言，还需要另外一个词法分析器用于调试命令。

有两种基本的方法来使一个程序处理两个词法分析器：合并的词法分析器或者把两个完整的词法分析器放到程序中

1.  **合并的词法分析器**

    你可以使用起始状态合并两个词法分析器。每个词法分析器的模式都被加上特定起始状态作为前缀。当词法分析器开始工作时，你需要写一小段代码来让 它进入合适的初始状态，这样就可以选择特定的词法分析器了，例如下面这一段代码（它将会被拷贝到yylex()的开头）：

    ```c
    %s INITA INITB INITC
    
    %%
    %{
    	extern first_tok, fist_lex;
    	if(first_lex){ // 在调用词法分析器之前，会设置first_lex作为它的起始状态
    		BEGIN(first_lex);
    		first_lex = 0;
    	}
    	if(first_tok){
    		int holdtok = fist_tok;
    		first_tok = 0;
    		return holdtok;
    	}
    %}
    %%
    ```

    这种合并的词法分析器与合并的语法分析器结合使用时，你通常需要通过代码来产生初始记号，以便于告知语法分析器那种语法正在使用。这种方法的有点是目标代码比较小。缺点就是其因为共享而引入的复杂性，你需要非常小心使用起始状态；你不能够一次激活两种词法分析器；对于不同词法分析器使用不同的输入源的情况处理会比较麻烦。

2.  **同一个程序中的多个完整的词法分析器**

    另外一种方法是在你的程序中包含两个词法分析器。这种技巧要求改变lex默认使用的函数和变量名，这样两个词法分析器才可以分别生成，然后编译到同一个程序中。

    flex提供了命令行选项和程序选项来改变生成的词法分析器所使用的名字的前缀。例如，下面这些选项可以让flex使用前缀"foo"而不是"yy"，并且生成的词法分析器源文件会是foolex.c。

    ```c
    %option prefix="foo"
    %option outfile="foolex.c"
    ```

    你也可以通过命令行选项来实现这一点：

    ```shell
    flex --outfile=foolex.c --prefix=foo foo.l
    ```

    任何一种方法生成的词法分析器又具有入口函数foolex()，它从标准文件fooin读取输入。不过稍微有点儿迷惑人的是，flex需要在词法分析器的最前面生成一大堆#define宏，它们会把标准的"yy"格式的名字重定义为选定的前缀格式。这使得你可以继续使用标准名字来编写你的词法分析器，而外部可见的名字则会使用选定的前缀。例如：

    ```c
    #define yyin fooin
    #define yyleng fooleng
    #define yylex foolex
    #define yyout fooout
    #define yytext footext
    #define yylineno foolineno
    ```

    

### 2.10 Flex 的选项通常的用法释疑

flex提供了几百个选项。大多数选在词法分析器文件的开头部分可以写成：

```c
%option name
```

或者在命令行中以--name形式。

如果你需要关闭一个选项只需要在该选项前面家no，例如：%option noyywrap或者--noyywrap。在大多数情况下，把选项放在%option的方式更为推荐，因为如果选项错误的话，词法分析器通常无法正常工作。关于Flex的所有选项，[点击查看更多](http://dinosaur.compilertools.net/flex/flex_17.html#SEC17)。



### 2.11 在Bison中使用可重入的Flex词法分析器

在Flex中打开可重入词法分析器的功能，需要在词法分析器的开头添加：

```
%option reentrant
```

在使用时，需要使用类似以下的代码：

```c
yyscan_t scanner;

if(yylex_init(&scanner)) { printf("no scanning today\n"); abort(); }

while(yylex(scanner)){
	... do something ...;
}
yylex_destroy(scanner);
```

在可重入词法分析器中，所有与当前词法分析相关的状态信息都被保存在yyscan_t变量中，它实际上是一个指针，指向了包含所有状态的结构。你通过yylex_init()来创建词法分析器，把yyscan_t的地址作为参数传入，而yylex_init()在成功时返回0，或者在它无法分配结构空间时返回1。然后你就可以把yyscan_t代入任何一次yylex()的调用中，最后通过yylex_destroy来删除yyscan_t。每次调用yylex_init都会创建一个独立的词法分析器，多个词法分析器可以同时生效，但需要确保每次调用yylex()时传入相应的yyscan_t结构。

使用flex和bison配合实现可重入的词法分析器和语法分析器时，与单独的可重入词法分析器有所不同。可重入语法分析器通常通过调用yylex来获取记号，它会传入一个指向记号值的指针，但不会包括flex所需的yyscan_t参数。flex提供了

```c
%option reentrant bison-bridge
```

通过在词法分析器中使用该选项，它可以把yylex的定义改为：

```c
int yylex (YYSTYPE * yylval_param, yyscan_t yyscanner);
```

并且会根据参数值来自动设置yylval的值。**另外一个与普通词法分析器不同的地方在与yylval将变成一个指向联合类型的指针而不是联合类型，所以以前yylval.member的使用需要更改为yylval->member。**