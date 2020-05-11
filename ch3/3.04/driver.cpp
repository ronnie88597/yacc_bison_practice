//
// Created by cmp on 2020/5/11.
//

#ifndef DRIVER_CPP
#define DRIVER_CPP

#include "driver.h"
#include <iostream>

using namespace Marker;
using namespace std;

Driver::Driver() : m_scanner(*this), m_parser(m_scanner, *this) {

}

Driver::~Driver() {

}

int Driver::parse() {
  m_scanner.switch_streams(cin, cout);
  return m_parser.parse();
}

#endif