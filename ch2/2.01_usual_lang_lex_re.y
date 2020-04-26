/*
// 【汇总】Flex实现词法分析器时常见的用于定义匹配模式的RE
*/

%{
#include <stdio.h>
enum TokenType
{
    INTEGER             = 1001, // 整数，123
    DECIMAL             = 1002, // 小数，123.554
    IDENTIFIER          = 1003, // 变量，adfa
    STRING              = 1004,
};
%}

%%
[-+]?[0-9]+                                                 { printf("INTEGER"); return INTEGER; }       // 识别整数
[a-zA-Z_][a-zA-Z0-9]*                                       { printf("IDENTIFIER"); return IDENTIFIER; } // 识别标识符
[-+]?(([0-9]*\.?[0-9]+)|([0-9]+\.[0-9]*))(E[+-]?[0-9]+)?    { printf("DECIMAL"); return DECIMAL; }       // 识别小数，支持小数的科学计数法识别
\"[^"]*\"                                                   { printf("STRING"); return STRING; }         // 识别字符串
"//"[^\n]*\n                                                { printf("###"); return 999; }               // 识别字符串
%%

/*
// 细心的朋友已经发现，对于整数字符串（如："123"），能够同时匹配以上的第1个规则和第3个规则。
// 下面一起来认识以下Flex是如何处理"相同的输入可能被多种不同的模式匹配"这种情况的：
//    1. Flex将匹配尽可能多的的字符串
//    2. 如果根据1处理后，仍然存在多个模式的话，Flex将选择更早定义的模式来匹配
//
*/