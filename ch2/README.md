# CH2 内容概览

### 2.01_usual_lang_lex_re.y

Flex实现词法分析器时常见的用于定义匹配模式的RE汇总

### 2.02_use_yyin_to_read_data_from_file.y

flex词法分析器默认从stdin读取输入

### 2.03_read_files.y

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

BEGIN动作也可以在规则部分的以缩进开头，例如：

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

**注意**：INITIAL起始条件指没有任何起始条件规则激活的时候。BEGIN(INITIAL)等效于 BEGIN(0)