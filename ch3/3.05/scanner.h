// file: scanner.h
// Created by cmp on 2020/5/11.
//

#ifndef FLEX_BISON_SCANNER_H
#define FLEX_BISON_SCANNER_H

/***********************************/
/*对yyFlexLexer进行继承，获得更多的控制
*
***********************************/

/* 重要 */
#if !defined(yyFlexLexerOnce)
#undef yyFlexLexer
#define yyFlexLexer Marker_FlexLexer  // 根据prefix修改

#include <FlexLexer.h>

#endif
/* 替换默认的get_next_token定义 */
#undef YY_DECL
#define YY_DECL Marker::Parser::symbol_type Marker::Scanner::nextToken()

#include "parser.hpp"

namespace Marker {
  class Driver;

  class Scanner : public yyFlexLexer {
  private:
    /* data */
    Driver &_driver;

  public:
    Scanner(Marker::Driver &driver) : _driver(driver) {}

    virtual Marker::Parser::symbol_type nextToken(); // 不需要手动实现这个函数，Flex会生成YY_DECL宏定义的代码来实现这个函数

    virtual ~Scanner() {}
  };
} /* Marker */


#endif //FLEX_BISON_SCANNER_H
