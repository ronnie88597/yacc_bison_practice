/*
// file: 1.04_NextToken_with_Flex.y
在词法分析的时候，经常我们需要一个NextToken的函数，这个函数每一次调用返回下一个识别了的Token
本例子就是结合Flex来实现NextToken函数的基本功能，来识别C语言中的token
该词法分析器仅支持标准C98的关键字识别，新的标准增加的关键字并不支持
*/

%{
enum TokenType
{
    INTEGER                 = 1001, // 整数，123
    DECIMAL                 = 1002, // 小数，123.554
    IDENTIFIER              = 1003, // 变量，adfa
    OPERATOR                = 1004, // 操作符，+/*
    KEYWORD                 = 1005, // 关键字，if/for
    L_PARENTHESIS           = 1006, // 左圆括号，(
    R_PARENTHESIS           = 1007, // 右圆括号，)
    L_SQUARE_BRACKET        = 1008, // 左方括号，[
    R_SQUARE_BRACKET        = 1009, // 右方括号，]
    L_BRACE                 = 1010, // 左大括号，{
    R_BRACE                 = 1011, // 右大括号，}
    QUESTION_SIGN           = 1012, // 问号，?
    COMMA                   = 1013, // 逗号，,
    COLON                   = 1014, // 冒号，:
    SEMICOLON               = 1015, // 分号，;
    POUND_SIGN              = 1016, // 井号，#
    LESS_THAN               = 1017, // 小于，<
    LESS_EQUAL_THAN         = 1018, // 小于等于，<=
    GREAT_THAN              = 1019, // 大于，>
    GREAT_EQUAL_THAN        = 1020, // 大于等于，>=

    QUOTATION               = 1021, // 单引号，'

    STRING                  = 1022, // 字符串，
    ANNOTATION              = 1023, // 单行注释，"
    MULTI_LINE_ANNOTATION   = 1024, // 多行注释，"

};
int yylval = 0;
%}

/*"+"                     { return OPERATOR; }*/
/*"-"                     { return OPERATOR; }*/
/*"*"                     { return OPERATOR; }*/
/*"/"                     { return OPERATOR; }*/
/*"%"                     { return OPERATOR; }*/
/*"->"                    { return OPERATOR; }*/
/*"&&"                    { return OPERATOR; }*/
/*"||"                    { return OPERATOR; }*/
/*"!"                     { return OPERATOR; }*/
/*"<<"                    { return OPERATOR; }*/
/*">>"                    { return OPERATOR; }*/
/*[&|~^]                  { return OPERATOR; }*/

%%
[*/+-]                  { return OPERATOR;} // 四则运算符 +-*/
"%"                     { return OPERATOR;} // 取模运符 %
"**"                    { return OPERATOR;} // 乘方运符 **
[~|&^]                  { return OPERATOR;}       // 位运算符 ~|&^
">>"                    { return OPERATOR;}       // 位运算符 >>
"<<"                    { return OPERATOR;}       // 位运算符 <<
"&&"                    { return OPERATOR;}       // 布尔运符 &&
"||"                    { return OPERATOR;}       // 布尔运符 ||
"!"                     { return OPERATOR;}       // 布尔运符 !
"->"                    { return OPERATOR;}       // 成员运算符号

"["                     { return L_SQUARE_BRACKET; }
"]"                     { return R_SQUARE_BRACKET; }

"("                     { return L_PARENTHESIS; }
")"                     { return R_PARENTHESIS; }

"{"                     { return L_BRACE; }
"}"                     { return R_BRACE; }

"<"                     { return LESS_THAN; }
"<="                    { return LESS_EQUAL_THAN; }
">"                     { return GREAT_THAN; }
">="                    { return GREAT_EQUAL_THAN; }

"?"                     { return QUESTION_SIGN; }
","                     { return COMMA; }
":"                     { return COLON; }
";"                     { return SEMICOLON; }
"#"                     { return POUND_SIGN; }
'                       { return QUOTATION; }


"auto"                  { return KEYWORD; }
"break"                 { return KEYWORD; }
"case"                  { return KEYWORD; }
"char"                  { return KEYWORD; }
"const"                 { return KEYWORD; }
"continue"              { return KEYWORD; }
"default"               { return KEYWORD; }
"do"                    { return KEYWORD; }
"double"                { return KEYWORD; }
"else"                  { return KEYWORD; }
"enum"                  { return KEYWORD; }
"extern"                { return KEYWORD; }
"float"                 { return KEYWORD; }
"for"                   { return KEYWORD; }
"goto"                  { return KEYWORD; }
"if"                    { return KEYWORD; }
"int"                   { return KEYWORD; }
"long"                  { return KEYWORD; }
"register"              { return KEYWORD; }
"return"                { return KEYWORD; }
"short"                 { return KEYWORD; }
"signed"                { return KEYWORD; }
"sizeof"                { return KEYWORD; }
"static"                { return KEYWORD; }
"struct"                { return KEYWORD; }
"switch"                { return KEYWORD; }
"typedef"               { return KEYWORD; }
"union"                 { return KEYWORD; }
"unsigned"              { return KEYWORD; }
"void"                  { return KEYWORD; }
"volatile"              { return KEYWORD; }
"while"                 { return KEYWORD; }


[-+]?[0-9]+                                                 { return INTEGER; } // 识别整数
[a-zA-Z_][a-zA-Z0-9_]*                                      { return IDENTIFIER; } // 识别标识符
[-+]?(([0-9]*\.?[0-9]+)|([0-9]+\.[0-9]*))(E[+-]?[0-9]+)?    { return DECIMAL; } // 识别小数，支持小数的科学计数法识别

\"[^"]*\"                                                   { return STRING; }           // 识别字符串

"//"[^\n]*\n                                                { return ANNOTATION; }   // 识别单行注释
"/*".*"*/"                                                  { return MULTI_LINE_ANNOTATION; }   // 识别多行注释

[ \t]                   { /*忽略空白字符*/ }
%%

int NextToken()
{
    /*
    每当调用yylex()时，它都会从全局输入文件yyin（默认为stdin）中扫描token。
    它一直持续到到达文件结尾（此时它返回值0）或它的其中一个动作执行return语句为止。
    */
    return yylex();
};

