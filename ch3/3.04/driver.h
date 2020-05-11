//
// Created by cmp on 2020/5/11.
//

#ifndef FLEX_BISON_DRIVER_H
#define FLEX_BISON_DRIVER_H

#include <iostream>
#include "scanner.h"
#include "parser.hpp"

namespace Marker {
  class Driver {
    friend class Scanner;

    friend class Parser;

  private:
    /* data */
    Parser m_parser;
    Scanner m_scanner;
  public:
    Driver();

    int parse();

    virtual ~Driver();
  };
} /*Marker */
#endif //FLEX_BISON_DRIVER_H
