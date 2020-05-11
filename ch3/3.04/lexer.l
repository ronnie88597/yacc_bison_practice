%{
  #include <iostream>
  #include <cerrno>
  #include <climits>
  #include <cstdlib>
  #include <string>

  #include "parser.hpp"//包含由parser.y生成的头文件
  #include "scanner.h" //包含yyFlexLexer子类的头文件
  #include "location.hh" //包含位置调试信息头文件
  static Marker::location loc;//声明位置实例
  # define YY_USER_ACTION  loc.columns (yyleng);
  #define yyterminate() Marker::Parser::make_END(loc);
  # undef yywrap
  # define yywrap() 1
%}
/* 声明使用C++版本FLEXER，c++是大小写不敏感的 */
%option c++

/* 支持调试 */
%option noyywrap debug

/* 使用Scanner::yylex() */
%option yyclass="Scanner"

/* 一些与编译常量使用该前缀否则为yy */
%option prefix="Marker_"

/*正则式的各种简写，使程序有层次感而显得明晰 */
string  \"[^\n"]+\"
/**/
ws      [ \t]+
alpha   [A-Za-z]
dig     [0-9]
name    ({alpha}|{dig}|\$)({alpha}|{dig}|[_.\-/$])*
num1    {dig}+\.?([eE][-]?{dig}+)?
num2    {dig}*\.{dig}+([eE][-]?{dig}+)?
number  {num1}|{num2}
id      ({alpha})+


%%
%{
  /*每次parse调用时都执行一次*/
  loc.step();
%}
{number}  return Marker::Parser::make_NUMBER(std::strtof(yytext,(&yytext+yyleng)),loc);
{ws}      loc.step();
\n     loc.lines(yyleng);loc.step();return Marker::Parser::make_EOL(loc);
\+       return Marker::Parser::make_PLUS(loc);
-       return Marker::Parser::make_MINUS(loc);
\*       return Marker::Parser::make_MUL(loc);
\/       return Marker::Parser::make_DIV(loc);
\(       return Marker::Parser::make_LPAREN(loc);
\)       return Marker::Parser::make_RPAREN(loc);
\|       return Marker::Parser::make_ABS(loc);
{id}      return Marker::Parser::make_IDENTIFIER(yytext,loc);
<<EOF>>   return yyterminate();
.        loc.step();
%%
//这里可以放一些C或者C++代码