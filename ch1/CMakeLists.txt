
execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/1.01_word_counter.c ${CMAKE_CURRENT_SOURCE_DIR}/1.01_word_counter.y)
add_executable(1.01_word_counter 1.01_word_counter.c)
target_link_libraries(1.01_word_counter PUBLIC
    -lfl)



execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/1.02_BritishEn_to_AmericanEn.c ${CMAKE_CURRENT_SOURCE_DIR}/1.02_BritishEn_to_AmericanEn.y)
add_executable(1.02_BritishEn_to_AmericanEn 1.02_BritishEn_to_AmericanEn.c)
target_link_libraries(1.02_BritishEn_to_AmericanEn PUBLIC
    -lfl)



execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/1.03_recognize_calculator_tokens.c ${CMAKE_CURRENT_SOURCE_DIR}/1.03_recognize_calculator_tokens.y)
add_executable(1.03_recognize_calculator_tokens 1.03_recognize_calculator_tokens.c)
target_link_libraries(1.03_recognize_calculator_tokens PUBLIC
    -lfl)


execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/1.04_NextToken_with_Flex.h ${CMAKE_CURRENT_SOURCE_DIR}/1.04_NextToken_with_Flex.y)
add_executable(1.04_NextToken_with_Flex 1.04_main.c)
target_link_libraries(1.04_NextToken_with_Flex PUBLIC
    -lfl)


execute_process(COMMAND
        bison -v --debug -o ${CMAKE_CURRENT_SOURCE_DIR}/1.05_first_calculator_with_bison.c
    ${CMAKE_CURRENT_SOURCE_DIR}/1.05_first_calculator_with_bison.y)


add_subdirectory(1.06)
