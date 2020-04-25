cmake_minimum_required(VERSION 3.14)
project(1.01_word_counter)

execute_process(COMMAND
    flex -o ${PROJECT_SOURCE_DIR}/1.01_word_counter.c ${PROJECT_SOURCE_DIR}/1.01_word_counter.l)

add_executable(1.01_word_counter 1.01_word_counter.c)

target_link_libraries(1.01_word_counter PUBLIC
    -lfl)



execute_process(COMMAND
    flex -o ${PROJECT_SOURCE_DIR}/1.02_BritishEn_to_AmericanEn.c ${PROJECT_SOURCE_DIR}/1.02_BritishEn_to_AmericanEn.l)

add_executable(1.02_BritishEn_to_AmericanEn 1.02_BritishEn_to_AmericanEn.c)

target_link_libraries(1.02_BritishEn_to_AmericanEn PUBLIC
    -lfl)



execute_process(COMMAND
    flex -o ${PROJECT_SOURCE_DIR}/1.03_recognize_calculator_tokens.c ${PROJECT_SOURCE_DIR}/1.03_recognize_calculator_tokens.l)

add_executable(1.03_recognize_calculator_tokens 1.03_recognize_calculator_tokens.c)

target_link_libraries(1.03_recognize_calculator_tokens PUBLIC
    -lfl)


execute_process(COMMAND
    flex -v --debug -o ${PROJECT_SOURCE_DIR}/1.04_NextToken_with_Flex.h ${PROJECT_SOURCE_DIR}/1.04_NextToken_with_Flex.l)

add_executable(1.04_NextToken_with_Flex 1.04_main.c)

target_link_libraries(1.04_NextToken_with_Flex PUBLIC
    -lfl)


execute_process(COMMAND
        bison -v --debug -o ${PROJECT_SOURCE_DIR}/1.05_first_calculator_with_bison.c ${PROJECT_SOURCE_DIR}/1.05_first_calculator_with_bison.y)

#add_executable(1.05_first_calculator_with_bison 1.05_first_calculator_with_bison.c)
#
#target_link_libraries(1.05_first_calculator_with_bison PUBLIC
#        -lfl)

add_subdirectory(1.06)
