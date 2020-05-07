/*
// 【汇总】Flex实现词法分析器时常见的用于定义匹配模式的RE
*/

%{
#include <stdio.h>
enum TokenType
{
    UNDEFINE                 = 1000,
    ANNOTATION               = 1001, // 注释
    INTEGER                  = 1002, // 整数，123
    DECIMAL                  = 1003, // 小数，123.554
    IDENTIFIER               = 1004, // 变量，adfa
    STRING                   = 1005, // 字符串
    ARITHMETIC_OPT           = 1006, // 四则运算符
    BITWISE_OPT              = 1007, // 位运算符
    MOD                      = 1008, // 取模运符 %
    POW                      = 1009, // 乘方运符 **

    BOOL_OPT                 = 1010, // 布尔运符 && || !

    MULTI_LINE_ANNOTATION    = 1011, // 多行注释 /**/
};
%}

%%
[*/+-]                                                      { printf("ARITHMETIC_OPT\n"); return ARITHMETIC_OPT;} // 四则运算符 +-*/
"%"                                                         { printf("MOD\n"); return MOD;} // 取模运符 %
"**"                                                        { printf("POW\n"); return POW;} // 乘方运符 **


[~|&^]                                                      { printf("BITWISE_OPT\n"); return BITWISE_OPT;}       // 位运算符 ~|&^
">>"                                                        { printf("BITWISE_OPT\n"); return BITWISE_OPT;}       // 位运算符 >>
"<<"                                                        { printf("BITWISE_OPT\n"); return BITWISE_OPT;}       // 位运算符 <<


"&&"                                                        { printf("BOOL_OPT\n"); return BOOL_OPT;}       // 布尔运符 &&
"||"                                                        { printf("BOOL_OPT\n"); return BOOL_OPT;}       // 布尔运符 ||
"!"                                                         { printf("BOOL_OPT\n"); return BOOL_OPT;}       // 布尔运符 !


[-+]?[0-9]+                                                 { printf("INTEGER\n"); return INTEGER; }         // 识别整数
[a-zA-Z_][a-zA-Z0-9_]*                                      { printf("IDENTIFIER\n"); return IDENTIFIER; }   // 识别标识符
[-+]?(([0-9]*\.?[0-9]+)|([0-9]+\.[0-9]*))(E[+-]?[0-9]+)?    { printf("DECIMAL\n"); return DECIMAL; }         // 识别小数，支持小数的科学计数法识别
\"[^"]*\"                                                   { printf("STRING\n"); return STRING; }           // 识别字符串


"//"[^\n]*\n                                                { printf("ANNOTATION\n"); return ANNOTATION; }   // 识别单行注释
"/*"([^*]|\*+[^/*])*"*/"                                                  { printf("MULTI_LINE_ANNOTATION\n"); return MULTI_LINE_ANNOTATION; }   // 识别多行注释


\n                                                          { printf("NEWLINE\n"); return UNDEFINE; }        // 识别换行符号
[ \t]                                                       { } // 忽略空格
.                                                           { printf("Mystery character %s\n", yytext); }    // 忽略未定义字符串
%%

/*
// 细心的朋友已经发现，对于整数字符串（如："123"），能够同时匹配以上的第1个规则和第3个规则。
// 下面一起来认识以下Flex是如何处理"相同的输入可能被多种不同的模式匹配"这种情况的：
//    1. Flex将匹配尽可能多的的字符串
//    2. 如果根据1处理后，仍然存在多个模式的话，Flex将选择更早定义的模式来匹配
//
*/