# 第一章
## 内容概览

### 1.01_word_counter.l

一个字数统计（word_counter）程序，程序读入一个文件然后报告这个文件的行数、单词树和字符数。

### 1.02_BritishEn_to_AmericanEn.l

将英式英语转为美式英语

### 1.03_recognize_calculator_tokens.l

用于将输入的计算表达式识别为token流，然后输入

### 1.04_NextToken_with_Flex.l

在词法分析的时候，经常我们需要一个NextToken的函数，这个函数每一次调用返回下一个识别了的Token

本例子就是结合Flex来实现NextToken函数的基本功能，来识别C语言中的token

该词法分析器仅支持标准C98的关键字识别，新的标准增加的关键字并不支持