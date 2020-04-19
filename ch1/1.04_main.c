//
// Created by cmp on 2020/4/19.
//

#include <stdbool.h>
#include <stdio.h>
#include "1.04_NextToken_with_Flex.h"

void printToken(int token) {
  switch (token) {
    case INTEGER             : {
      printf("INTEGER %d\n", atoi(yytext));
      break;
    }
    case DECIMAL             : {
      printf("DECIMAL %f\n", atof(yytext));
      break;
    }
    case IDENTIFIER          : {
      printf("IDENTIFIER %s\n", yytext);
      break;
    }
    case OPERATOR            : {
      printf("OPERATOR %s\n", yytext);
      break;
    }
    case KEYWORD             : {
      printf("KEYWORD %s\n", yytext);
      break;
    }
    case L_PARENTHESIS       : {
      printf("L_PARENTHESIS %s\n", yytext);
      break;
    }
    case R_PARENTHESIS       : {
      printf("R_PARENTHESIS %s\n", yytext);
      break;
    }
    case L_SQUARE_BRACKET    : {
      printf("L_SQUARE_BRACKET %s\n", yytext);
      break;
    }
    case R_SQUARE_BRACKET    : {
      printf("R_SQUARE_BRACKET %s\n", yytext);
      break;
    }
    case L_BRACE             : {
      printf("L_BRACE %s\n", yytext);
      break;
    }
    case R_BRACE             : {
      printf("R_BRACE %s\n", yytext);
      break;
    }
    case QUESTION_SIGN       : {
      printf("QUESTION_SIGN %s\n", yytext);
      break;
    }
    case COMMA               : {
      printf("COMMA %s\n", yytext);
      break;
    }
    case COLON               : {
      printf("COLON %s\n", yytext);
      break;
    }
    case SEMICOLON           : {
      printf("SEMICOLON %s\n", yytext);
      break;
    }
    case POUND_SIGN          : {
      printf("POUND_SIGN %s\n", yytext);
      break;
    }
    case LESS_THAN     : {
      printf("LESS_THAN %s\n", yytext);
      break;
    }
    case LESS_EQUAL_THAN     : {
      printf("LESS_EQUAL_THAN %s\n", yytext);
      break;
    }
    case GREAT_THAN     : {
      printf("GREAT_THAN %s\n", yytext);
      break;
    }
    case GREAT_EQUAL_THAN     : {
      printf("GREAT_EQUAL_THAN %s\n", yytext);
      break;
    }
    case QUOTATION     : {
      printf("QUOTATION %s\n", yytext);
      break;
    }
    case DOUBLE_QUOTATIONS     : {
      printf("DOUBLE_QUOTATIONS %s\n", yytext);
      break;
    }

    default:
      printf("[E]>>>Unknown TokenType %d\n", token);
  }
}

int main() {
  int token = 0;
  while (token = NextToken()) {
    printToken(token);
  }
  return 0;
}