//
// Created by cmp on 2020/5/11.
//

#include "driver.h"
#include <iostream>

using namespace Marker;
using namespace std;

Driver::Driver() : _scanner(*this), _parser(_scanner, *this) {

}

Driver::~Driver() {

}

int Driver::parse() {
  _scanner.switch_streams(cin, cout);
  return _parser.parse();
}