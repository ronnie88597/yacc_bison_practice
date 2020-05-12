# CH3 内容概览

### 3.01 bison基本概念及语法介绍

由于本节篇幅较大，这里先将目录列出来以便于读者查阅感兴趣的内容(*^__^*) 嘻嘻……：

-   **移进/规约分析**
-   **bison的两种语法分析方法**
-   **bison的基本规则**

-   **%start声明**
-   **%union声明**
-   **%type声明**
-   **%name-prefix声明**
-   **%inital-action**
-   **%parse-param**
-   **文字记号**
-   **bison中所有特殊的符号汇总**
-   **符号的值**
-   **声明符号的类型**
-   **记号**
-   **记号编号**
-   **记号值**
-   **位置**
-   **递归的语法规则**
-   **错误记号和错误恢复**
-   **继承属性（$0）**
-   **继承属性的符号类型**
-   **bison日志文件**
-   **bison库文件**



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
    
    /* 第一部分为定义部分，此部分主要包括选项、文字块、注释、声明符号、语义值数据类型的集合、指定开始符号及其它声明等等。
       文字块存在与%{和%}之间，它们将被原样拷贝到生成文件中。*/
    %start calclist /* 指定起始符号（start symbol）有时也称为目标符号（goal symbol） */
    %token NUMBER /* 声明tokens记号，以便于告诉bison在语法分析程序中记号的名称。通常这些记号总是使用大写字母，虽然bison本身并没有这个要求。 */
        
    %{
      /* 文字块，该部分的内容将直接复制到生成的代码文件的开头，以便它们在使用yyparse定义之前使用。 */
      #define _GNU_SOURCE
      #include <stdio.h>
      #include "ptypes.h"
    %}
    
    %%
    /* 第二部分，主要是语法规则 */
    calclist: /* 空规则 -- 起始符号（start symbol）有时也称为目标符号（goal symbol） */
    /* 如果没有指定语义动作，bison将使用默认的动作： { $$ = $1; }*/
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
/*第三部分，此部分的内容将直接逐字复制到生成的代码文件末尾。该部分主要用于对之前一些声明了的函数进行实现。 */
    ```

    关于第一部分，bison可以在该部分声明的所有内容，[请查看](http://www.gnu.org/software/bison/manual/bison.html#Declarations)。

    关于第一部分，bison总是可以接受形如%{...%}的C代码文字块。有时这些代码必须放置在所生成程序中的特定位置，使用文字块会显得不够灵活，作为替代方案，bison提供了`%code[place]{code}`用于表示代码的用途以及生成代码的位置。选项place称之为限定符（qualifier），表明代码在生成程序中的放置位置。目前C语言程序的位置包括top、provides和requires。对应的位置也就是文件的顶部、在YYSTYPE与YYLTYPE的定义之前和定义之后。此处不再对它进行详解，[欲知详情请看](http://www.gnu.org/software/bison/manual/bison.html#g_t_0025code-Summary)。
    
    bison通过把每个部分插入到标准的框架文件中来创建输出文件。语法规则会被编译生成数组的形式，数组的内容代表了可以匹配输入记号流的状态机。语义动作中的`$N`和`@N`的值会首先翻译成C代码，然后被放置到yyparse()中的switch语句中，yyparse()会在规约发生时执行相应的动作。框架文件中存在着一些不同版本的代码，bison将基于当前使用的选项来决定哪个版本被使用。

-   **%start声明**

    %start声明起始规则，也就是语法分析器首先开始分析的规则，默认是第一个规则。大多数情况下，最清楚的表达语法的方式是自上而下，起始规则放在第一个，这样%start就不需要了。起始符号必须具备一个空规则，旨在让开始输入的记号能够从起始符号开始匹配。

-   **%union声明**

    %union声明标识出了符号值可能拥有的所有C类型，格式如下：

    ```c
    %union{
    ... 域声明 ...
    }
    ```

    域声明将被原封不动地拷贝到输出文件中类型为YYSTYPE的C的union声明里。

    关于YYSTYPE，bison里的YYSTYPE默认是int类型的，可以用%union将YYSTYPE定义为联合体。bison生成代码时，将会在name.tab.c文件中定义YYSTYPE的yylval变量，如下所示：

    ```c
    /* The lookahead symbol.  */
    int yychar;
    
    /* The semantic value of the lookahead symbol.  */
    YYSTYPE yylval;
    /* Number of syntax errors so far.  */
    int yynerrs;
    ```

    并且在name.tab.h后文件中将yylval声明为extern的，如下：

    ```c
    union YYSTYPE
    {
    #line 10 "/home/cmp/work_dir/source_code/yacc_bison_practice/ch3/3.02/3.02_create_AST_with_bison.y" /* yacc.c:1909  */
    
      struct ASTNode *a;
      double d;
    
    #line 64 "3.02_create_AST_with_bison.tab.h" /* yacc.c:1909  */
    };
    
    typedef union YYSTYPE YYSTYPE;
    # define YYSTYPE_IS_TRIVIAL 1
    # define YYSTYPE_IS_DECLARED 1
    #endif
    
    
    extern YYSTYPE yylval;
    ```

    进一步还可以将YYSTYPE定义为我自己定义的一个struct的指针，然后作为一个全局变量，让lex在扫描的时候，可以直接把扫描的东西放到yylval的数据结构中去。

-   **%type声明**

    使用%type声明非终结符的类型。格式如下：

    ```c
    %type <type> name, name, ...
    ```

    每个type的名字必须是用%union定义过。而每个name就是非终结符的名字。对于记号而言，你需要使用%token, %left, %right, %nonassoc，这些声明不仅可以用来指明记号的类型，还可以定义优先级和结合性[点击查看关于它们更多的信息](https://blog.csdn.net/weixin_46222091/article/details/106007305)

-   **%name-prefix声明**

    你可以在bison源代码中使用特定的声明来更改bison生成的语法分析器所使用的名字前缀。如下：

    ```c
    %name-prefix "pdq"
    ```

    这将产生一个具有入口函数为pdqparse()的语法分析器，而它将调用pdqlex()，诸如此类。

    具体来说，被影响的名字包括yyparse(), yylex(), yyerrror(), yylval, yychar（该变量报错最近读取的符号，它在打印错误消息时很有用）, yydebug。

    同时也可以通过命令行改变语法分析器的前缀：

    ```shell
    bison -d -p pdq -b pref mygram.y
    ```

    将产生pref.tab.c和pref.tab.h的语法分析器。

-   **%inital-action**

    如果你在语法分析器启动的时候需要初始化一些内容，你可以使用%initial-action{some code}来让bison拷贝somecode到yyparse的开始部分。具体放置的位置将是标准初始化代码之后，所以你无法把变量声明也放在该代码中（它们会被允许，但是你的动作代码无法访问它们）。如果你需要定义自己的分析时间变量，你必须使用静态全局变量，或者通过%parse-param把它们作为参数传递。

-   **%parse-param**

    通常你调用yyparse()不需要任何参数，如果语法分析器需要从周边程序导入一些信息，它可以使用全局变量，或者你也可以为其定义添加参数：

    ```c
    %parse-param { char *modulename }
    %parse-param {int intensity}
    ```

    这允许你调用yyparse("mymodule", 42)，然后在语法分析器的动作代码中使用modulename和intensity。注意这里并没有使用分号和结束符号，因为参数就会被直接放置在yyparse定义中的两个圆括号之间。

    通常的语法分析器很少有机会使用分析参数，但是如果你需要产生一个可能被传递地或者多线程中调用的多次的纯语法分析器，参数定义是为每个语法分析器的实例提供参数的最简单的方法。

-   **文字记号**

    bison把单引号引起的字符也作为一个记号看待。例如：

    ```c
    expr: '(' expr ')';
    ```

    左圆括号和右圆括号都是文字记号（literal token）。文字记号的编号也就是它们在本地字符集（通常是ASCII）对应的数值，与C语言用的字符的数值一致。

    词法分析器通常从输入中对应的单个字符来产生这些记号，但是如同其他记号一样，输入字符和产生的记号之间的对应关系是完全有词法分析器决定的。一种常见的技术是让词法分析器把所有不能识别的字符作为文字记号看待。例如，在flex词法分析器中：

    ```c
    return yytext[0];
    ```

    这包括了语言中的所有单字符操作符，而让Bison来捕获哪些输入中存在不能识别的字符，然后报告错误。

    bison也允许你为字符串定义一个别名来方便识别记号，例如：

    ```c
    %token NE "!="
    %%
    ...
    exp: exp "!=" exp;
    ```

    它定义了记号NE，使得你可以在语法分析器中任意地使用NE或者!=，词法分析器读到这个单词时，必须依然返回NE的内部记号编号，而不是一个字符串。

-   **bison中所有特殊的符号汇总**

    由于bison处理符号记号而不是字面文本，它的输入字符集比词法分析器要来得简单。下面是Bison所使用的特殊字符列表：

    %，具有两个百分号的行用来分割bison语法的各个部分

    \$，在语义动作中，美元符号引入一个值引用，例如，​\$3代表规则右部第三个符号的值。

    @，在语义动作中，@符号引入一个位置引用，比如@2代表规则右部第二个符号的位置。

    '，文字记号用单引号

    "，bison允许你把双引号引起的字符串定义为记号的别名

    <>，在语义动作中的值引用里，你可以通过扩在尖括号里的类型名来覆盖值的默认类型，例如$<xtype>3

    {}，语义动作的C代码使用花括号括起

    ;，规则部分的每个规则都必须使用分号结尾，后面又紧跟以竖线开始的另一个规则的规则可以出该。

    /，当两个连续的规则具有相同的左部时，第二个规则可以把左部的符号和冒号替换为竖线

    :，在每条规则中，冒号出现在规则左部的非终结符之后

-   **符号的值**

    bison语法分析器中的每个符号，包括记号和非终结符，都可以有关联的值。如果记号是NUMBER，那么它的值也就是特定的数值；如果它是STRING，它的值可能是指向字符串拷贝的指针；如果是SYMBOL，它的值可能是指向符号表中描述该符号条目的一个指针。每个不同类型的值都对应了不同的C类型：表示数值型的int或者double，表示字符串的char *，以及指向表示符号的结构的指针。bison可以方便地为不同的符号分配不同的类型，所以它能够自动为每个符号选择正确的类型。

-   **声明符号的类型**

    在内部，bison通过C语言的联合类型来声明符号值，使得它可以包含所有类型。你在%union声明中列出所有肯能的类型。bison会把它们转化为联合类型的typedef，该类型被成为YYSTYPE。对于每个在动作代码中需要被使用或者设置值的符号，你必须声明它的类型。你可以使用%type来声明非终结符的类型。

    接着，当你用过$$，$1等等来使用符号值时，bison将自动使用联合类型中的恰当域。

    bison并不分析任何的C代码，所以任何你所犯下的符号拼写上的错误，例如使用了一个并不在联合类型中的类型名字或者使用了一个C语言不允许的域，都将导致生成的C程序的错误。

-   **记号**，Token

    记号，或者说终结符，是词法分析器传递给语法分析器的符号。当bison语法分析器需要新的记号时，它调用yylex()，这将从输入中返回下一个记号。在输入结束时，yylex()返回0。

    记号可以是通过%token定义的符号，或者是单引号中的各个字符。所有被用来作为记号的符号必须在定义部分显示声明，例如：

    ```c
    %token UP DOWN LEFT RIGHT
    ```

    记号也可以通过%left，%right，%nonassoc来声明，它们都具有和%token一样的语法格式。

-   **记号编号**

    在词法分析器和语法分析器中，记号通过小型整数来唯一标识。一个文字记号的记号编号就是它在本地字符集（通常是ASCII）中的数值，而且也与被引起字符的C语言的值一致。

    **符号记号通常由bison来负责编号，该编号要大于任何可能的字符编码，所以它们不会和文字记号发生冲突。**你也可以在%token的记号名字后直接加上要赋予的编号：

    ```c
    %token UP 50 DOWN 60 LEFT 17 /* 当使用英文名字来定义ASCII字符集中的字符可以使用字符的值，其他情况必须编号要大于任何可能的字符编码，避免发生冲突。 */
    %token RIGHT 25
    ```

    给两个记号赋予相同的编号是错误的行为。在大多数情况下，让bison来选择每个记号的编号最简单易懂。

    *注意：记号编号可以代表Token的类型，也称为**语法范畴**（syntactic category）。*

-   **记号值**

    bison中的每个符号都可以有关联值。由于记号可以有值，你需要在词法分析器返回记号给语法分析器时来设置值。记号值正式保存在变量yylval中，在最简单的语法分析器里，yylval就是简单的int变量，你可以在flex词法分析器中做如下设置：

    ```c
    [0-9]+     { yylval = atoi(yytext); return NUMBER; }
    ```

    不过，在大多数情况下，不同的符号会有不同的值类型。

    在语法分析器中，你必须定义所有拥有值的记号的值类型。你只需要把相应的联合类型中的标记名字用尖括号括起来，然后放到%token或优先级声明中。你可以如下定义你的值类型：

    ```c
    %union{
    	enum optype opval;
    	double dval;
    }
    
    %nonassoc <opval> RELOP
    %token <dval> REAL
    
    %union{
    char * sval;
    }
    ...
    %token <sval> STRING;
    ```

    这个例子中，RELOP是一个关系操作符，比如==或者>，而记号值表明其具体的操作符。当你返回记号时，你需要设置yylval中union相应的域。本例子中，你可以在词法分析器中如下进行设置：

    ```c
    %{
    #include "parser.tab.h"
    %}
    ...
    [0-9]+\.[0-9]*  { yylval.dval = atof(yytext); return REAL; }
    \"[^]*\"        { yylval.sval = strdup(yytext); return STRING; }
    "=="            { yyval.opval = OPEQUAL; return RELOP; }
    ```

    REAL的值是一个double类型，所以它被放在yylval.dval中，而STRING的值是char *类型，所以它被放在yylval.sval中。

-   **位置**

    为了辅助错误报告，bison提供了位置信息，它可以跟踪语法分析器里每个符号的行与列范围。位置信息可以通过%locations来显式地激活或者在动作代码里隐式地使用位置信息。词法分析器必须在返回记号前记录当前行与列信息，并且为该记号在yylloc中设置位置范围（flex词法分析器自动记录行号，但是你需要自行记录列数）。语法分析器在每次规则被规约时会执行一个默认规则来设置左部符号的位置范围，该范围为第一个右部符号的开始行与列到最后一个右部符号的结束行与列。

    在动作代码中，每个符号的位置可以使用@$来代表左部符号，第一个右部符号使用@1，依次类推。每个位置信息实际上是一个结构，你可以使用类似于@3.first_column这样的表达式来引用该结构的域。

    对于大多数语法分析器来说，位置信息已经远远超过错误报告的需求。分析错误依然只需要报告分析错误所在的单个记号，所以只有当动作代码报告位置范围的时候，用户才会看到。最有可能使用它们的地方是集成开发环境，它可以通过位置信息来高亮显示源代码以指出具体错误。

-   **递归的语法规则**

    为了分析不定长的项目列表，你需要使用递归规则，也就是用自身来定义自己。例如，下面这个例子分析一个可能为空的数字列表：

    ```c
    numberlist:  /* 空规则 */
              | numberlist NUMBER
              ;
    ```

    递归规则的实现完全依赖于具体需要分析的语法。下面这个例子分析一个通过逗号分隔的不为空的表达式列表，其中的expr在语法的其他地方已经被定义：

    ```c
    exprlist: expr
            : exprlist ',' expr
            ;
    ```

    也可能存在交互的递归规则，它们彼此引用对方：

    ```c
    exp: term
       | term '+' term
       ;
    
    term: '(' exp ')'
        | VARIABLE
        ;
    ```

    任**何递归规则或者交互递归规则组里的每个规则都必须至少有一条非递归的分支（不指向自身）**；否则，将没有任何途径来终止它所比匹配的字符串，这是一个错误。

    #### 左递归和右递归

    当你编写一个递归规则时，你可以把递归的引用放在规则右部的左端或者右端，例如：

    ```c
    exprlist: exprlist ',' expr; /* 左递归 */
    exprlist: expr ',' exprlist; /* 右递归 */
    ```

    大多数情况下，你可以选择任意一种方式来编写语法。**bison处理左递归要比处理右递归更有效率**。这是因为它的内部堆栈需要追踪到目前位置所有还处在分析中规则的全部符号。

    如果使用右递归，而且有个表达式包含了10个子表达式，当读取第10个表达式的时候，堆栈中会有20个元素：10个表达式各自有expr和逗号。当表达式结束时，所有嵌套的exprlist都需要按照从右向左的顺序来规约。另一个方面，如果你使用左递归的版本，exprlist将在每个expr之后进行规约，这样内部堆栈中列表将永远不会超过三个元素。

    具有10个元素的表达式列表不会对语法分析器造成什么问题。但是我们的语法经常需要分析拥有成千上万的元素的列表，尤其是当程序被定义为语句的列表时：

    ```c
    %start program
    
    %%
    program: statementlist;
    
    statementlist: statement
                 | statementlist ';' statement
    statement: ...
    ```

    这个例子中，假定有一个5000条语句的程序需要分析，那么列表中将包括语句和分号10000个元素，而右递归版本将耗费太多的内存空间。

    当你确定列表中的元素个数很少而且你需要把它们放到一个链表中，右递归语法就比较有用：

    ```c
    thinglist: THING { $$ = $1; }
             | THING thinglist { $1->next = $2; $$ = $1; }
    	     ;
    ```

    如果你对这个例子使用左递归语法的话，你就必须在最后把链表中倒序的内容在一次翻转，如果你需要在每次添加是找到链表的末端。

    你可以定义YYINITDEPTH来控制语法分析器堆栈的长度，表明堆栈的初始大小，通常为200，也可以定义YYMAXDEPTH来设置堆栈长度的最大值，通常为1000。例如：

    ```c
    %{
    #define YYMAXDEPTH 50000
    %}
    ```

    每个堆栈元素的大小是语义值的大小（%union元素的最大长度）加上2个字节的记号编号，如果你使用位置信息，还要加上16个字节。在具有上千MB虚拟内存的工作站上100000元素的堆栈大致需要2到3MB，但在更小的嵌入式系统中，你可能会希望重写你的语法来减少堆栈大小。

-   **错误记号和错误恢复**

    bison语法分析器总是尽可能早地检测语法错误，也就是，一旦它们发现一个记号没有合适的分析时，它们就会报错。当bison检测到语法错误时，或当它无法分析接收到的输入时，它将尝试基于下面的步骤来从错误中恢复：

    1.  它调用yyerror("syntax error")。报告错误给用户。
    2.  它抛弃任何部分分析的规则，直到它回到一个能够移进特殊符号error的状态。
    3.  它重新开始分析，首先会移进一个error。
    4.  如果在成功移进三个符号之前另一个错误发生，bison不会报告该错误，直接回到步骤2。

    [点击查看更多关于错误恢复的信息](http://www.gnu.org/software/bison/manual/bison.html#Error-Recovery)

-   **继承属性（$0）**

    bison的符号值可以作为继承属性（inherited attribute）或者综合属性（synthesized attribute）来使用（当bison提到"值"时，通常指编译器语境下的"属性"）。常见的继承属性是记号值，它们是语法分析树的叶子节点。在理论上每当一条规则被规约，信息就会在分析树中向上移动，而动作根据规约右部的符号值来综合获得结果符号($$)的值。

    有时候你会希望通过不同的方式来传递信息，比如从语法分析树的根节点到叶子节点。考虑以下这个例子：

    ```c
    declaration: class type namelist;
    
    class:   GLOBAL { $$ = 1; }
         |   LOCAL  { $$ = 2; }
         ;
    
    type:    REAL { $$ = 1; }
        |    INTEGER { $$ = 2; }
        ;
    
    namelist: NAME { mksymbol($0, %-1, $1); }
            | namelist NAME { mksymbol($0, %-1, $2); }
    ```

    考虑到错误检查和输入符号表的需要，如果能够在namelist的动作中就可以获得类和类型会比较有用。bison通过允许访问它内部堆栈中的符号来实现这一可能，这些在当前规则左部符号之前的值分别表示为\$0，\$1等等。本例中，mksymblo()调用中的\$0指向type的值，它在堆栈中出现在namelist产生式的符号之前，它根据type是REAL还是INTEGER会有值1或者2。$-1指向class的值，它将基于class是GLOBAL还是LOCAL而具有值1或者2。

    虽然继承属性有它的用处，但它也可能导致一些难以发现的错误。使用继承属性的动作需要考虑该规则在语法中出现的每个地方。这个例子中，如果更改语法使得在其他地方也是用namelist，那么你就必须确保namelist出现的地方，相应的符号也在它前面出现，这样\$0和\$-1才可能得到正确的值：

    ```c
    declaration: STRING namelist; /* 当发生错误 */
    ```

    继承属性有时候非常有用，特别是哪些复杂的语法，比如C语言的变量声明。但通常来说更安全和更简单的方法是为那些需要从继承属性里获取的值使用全局变量。在前例子中，规则namelist可以创建一个被声明名字的引用链表，然后返回指向该链表的指针作为规则的值，规则declaration的语义动作可以获得类、类型和namelist的值。并且把类和类型赋予namelist中相关的名字。

-   **继承属性的符号类型**

    当你使用一个继承属性的值时，常见的值声明计算（例如%type）并不管用。因为针对该值的符号并不出现在规则中，bison无法判定什么是正确的类型。你必须在动作代码中使用显示类型来提供类型名字。前例中，如果class和type的类型分别是cval和tval，最后两行可能需要如下编写：

    ```c
    namelist: NAME          { mksymbol($<tval>0, $<cval>-1, $1); }
            | namelist NAME { mksymbol($<tval>0, $<cval>-1, $2); }
    ```

    

-   **bison日志文件**

    bison可以创建日志文件，通常命名为name.output，它展示了语法分析器的所有状态和状态的变迁。使用选项--report=all可以生成相应的日志文件。

-   **bison库文件**

    bison从它的前身yacc继承了带有辅助例程的库文件。你可以通过增加编译链接选项-ly，来链接库文件中的main()和yyerror()。

    ```c
    int main(int ac, char** av){
    	yyparse();
    	return 0;
    }
    ```

    ```c
    yyerror(char * errmsg){
    	fprintf(stderr, "%s\n", errmsg);
    }
    ```

    

### 3.02 使用bison在语法分析中构建抽象语法树AST

在编译器中最强大的数据结构之一就是抽象语法树（Abstract Syntax Tree， AST）。抽象语法树实在语法树的基础上去掉不需要关注的节点信息而形成的。语法分析器创建AST后，就可以通过对树的遍历进行更多的分析和计算。

### 3.03 bison移进/规约冲突和操作符优先级

移进/规约冲突一般是由文法二义性造成的，关于二义性[可以看看这篇文章](https://blog.csdn.net/weixin_46222091/article/details/104447726)，以及[这位中科院老师的讲解](https://www.bilibili.com/video/BV17W41187gL?p=35)。对于这种问题bison提供了一个聪明的方法，它可以在语法规则之外单独描述优先级。这不仅消除了二义性，也使得语法分析器代码变得短小而且易于维护。

#### bison操作符优先级的规则

bison操作符优先级的规则，使用`%left`，`%right`，`%nonassoc`或`%precedence`声明记号并指定其优先级和结合性。它的语法与`%token`语法非常相似，如下：

``` c
%left symbols…
%left <type> symbols…
```

以表达式“ x op y op z”为例，运算符op的关联性决定了运算符嵌套，是通过先将x与y分组还是先将y与z分组来解析。

1.  ％left指定左相关性（将x与y优先分组）
2.  ％right指定右相关性（将y与z优先分组）
3.   ％nonassoc未指定结合性，这意味着“ x op y op z”被视为语法错误。
4.  ％precedence仅赋予符号优先级，并且根本不定义任何关联性。使用此命令仅定义优先级，并保留由于启用了结合性而引起的任何潜在冲突。

运算符的优先级确定它如何与其他运算符嵌套。在单个优先级声明中声明的所有标记都具有相同的优先级，并根据它们的关联性嵌套在一起。当在不同优先级声明中声明的两个标记相关联时，**后一个声明的标记具有更高的优先级**，并且首先分组。

结合下面的一个例子进一步学习bison操作符的优先级规则：

```c
%{
    enum Node_T{
        NT_UNDEF,
        NT_ADD,
        NT_SUB,
        NT_MUL,
        NT_DIV,
        NT_ABS,
        NT_NEG,
    };
    
    struct ASTNode *newast(int NodeType, struct ASTNode *Lft, struct ASTNode *Rht);
    struct ASTNode *newnum(double d);
%}

/* %union关键字声明了语法规则中所有语法值可能会用到的数据类型的一个集合 */
%union{
    struct ASTNode *a;
}
/* 声明的顺序决定了优先级，越后声明的优先级越高。bison遇到移进/规约冲突时，它将查询优先级表，来解决冲突 */
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS // UMINUS为符号操作符的伪记号。使用%nonassoc来声明'|'和UMINUS，表示这两个操作符没有结合性，并且它们具有最高的优先级。
    
%type <a> exp

%%
...
exp: exp '+' exp { $$ = newast(NT_ADD, $1, $3); }
   | exp '-' exp { $$ = newast(NT_SUB, $1, $3); }
   | exp '*' exp { $$ = newast(NT_MUL, $1, $3); }
   | exp '/' exp { $$ = newast(NT_DIV, $1, $3); }
   | '|' exp     { $$ = newast(NT_ABS, $2, NULL); }
   | '(' exp ')' { $$ = $2; }
   | '-' exp %prec UMINUS   { $$ = newast(NT_NEG, NULL, $2); } // '-'原本声明时的优先级要小于'*'，使用%pre UMINUS，可以让'-'拥有UMINUS的优先级。从而使得表达出"负号"的效果
   | NUMBER { $$ = newnum($1); }
%%
```

#### 什么时候不应该使用优先级规则

使用优先级规则解决移进/规约冲突时，有的时候会写出让人难以明白的语法规则。例如下面情况：表达式语法或解决在if/then/else语言结构的语法中的"dangling else"冲突，如下：

一个经典的例子：
$$
\begin{aligned}
Statement \rightarrow&\ \text{if}\ Expr\ \text{then} \ Statement\ \text{else}\ Statement\\
&|\text{if}\ Expr\ \text{then} \ Statement\\
&|Assignment\\
&|\ \ ...other statements...
\end{aligned}
$$
从这个语法片段可以看出，else是可选的。不幸的是，下列代码片段：

$\text{if}\ Expr1\ \text{then}\ \text{if}\ Expr2\ \text{then}\ Assignment1\ \text{else}\ Assignment2$

这种语法的二义性，应该通过**修正语法**来解决冲突。`引入新的规则`来确定到底由哪个if来控制特定的else子句。应该将上面的语法规则修改为：
$$
\begin{aligned}
Statement \rightarrow&\ \text{if}\ Expr\ \text{then} \ Statement\\
&|\text{if}\ Expr\ \text{then} \ WithElse\ \text{else}\ Statement\\
&|Assignment\\
WithElse \rightarrow&\ \text{if}\ Expr\ \text{then} \ WithElse\ \text{else}\ WithElse\\
&|Assignment\\
\end{aligned}
$$
通常出现二义性语法都可以通过`引入新的规则`来消除二义性，这样做会增加语法树的高度。



### 3.04 flex和bison进阶，产生C++语法分析器



### 3.05 flex和bison实现简单的C--编译器并生成obj文件

从第一章写到第三章，终于写到这里了，终于可以做一个名正言顺的简单编译器了。。(*^__^*) 嘻嘻……

本节主要是实现简单的C--编译器并生成obj文件，我将主要的中心放在结合flex和bison的强大功能，做词法、语法分析、以及简单的语法制导翻译，最终生成LLVM IR上。至于LLVM IR的优化，指令选择，指令调度，寄存器分配等并不打算自己开发，直接使用LLVM所提供的相关功能。

以下废话要开始了

。。。。。。。。。。。。。**时间紧的朋友可以跳过**

```
不直接开发其主要原因还是目前对LLVM的掌握尚浅，以及针对特定CPU架构的指令选择，指令调度，寄存器分配等的知识储备不够。后面我还会进一步做关于编译器的几大方面的学习：

1.  结合LLVM的基础设施对AMD架构部分基本指令进行指令选择，指令调度，寄存器分配等进行实践，并且陆续将积累的很多心得和体会分享到博客中；
2.  结合当前国内外关于编译器优化的文献进行研究，并实践其中部分有意思的编译器优化的最新技术，将心得和体会分享到博客中；
3.  罗列当前主流编译器其中用到的重要算法，对这些重要算法及其相关数据结构进行剖析，将心得和体会分享到博客中；
```

重要事情说三遍：**有兴趣的请关注一下我哟。** **有兴趣的请关注一下我哟。** **有兴趣的请关注一下我哟。**

。。。。。。。。。。。。。。好了废话了一大堆，言归正传

