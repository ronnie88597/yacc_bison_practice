include(${PROJECT_SOURCE_DIR}/cmake/clean_flex_bison_generate_code.cmake)


execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_BINARY_DIR}/1.01_word_counter.c ${CMAKE_CURRENT_SOURCE_DIR}/1.01_word_counter.l)
add_executable(1.01_word_counter ${CMAKE_CURRENT_BINARY_DIR}/1.01_word_counter.c)
target_link_libraries(1.01_word_counter PUBLIC
    -lfl)

execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_BINARY_DIR}/1.02_BritishEn_to_AmericanEn.c ${CMAKE_CURRENT_SOURCE_DIR}/1.02_BritishEn_to_AmericanEn.l)
add_executable(1.02_BritishEn_to_AmericanEn ${CMAKE_CURRENT_BINARY_DIR}/1.02_BritishEn_to_AmericanEn.c)
target_link_libraries(1.02_BritishEn_to_AmericanEn PUBLIC
    -lfl)

execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_BINARY_DIR}/1.03_recognize_calculator_tokens.c ${CMAKE_CURRENT_SOURCE_DIR}/1.03_recognize_calculator_tokens.l)
add_executable(1.03_recognize_calculator_tokens ${CMAKE_CURRENT_BINARY_DIR}/1.03_recognize_calculator_tokens.c)
target_link_libraries(1.03_recognize_calculator_tokens PUBLIC
    -lfl)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/)
execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_BINARY_DIR}/1.04_NextToken_with_Flex.h ${CMAKE_CURRENT_SOURCE_DIR}/1.04_NextToken_with_Flex.l)
add_executable(1.04_NextToken_with_Flex 1.04_main.c)
target_link_libraries(1.04_NextToken_with_Flex PUBLIC
    -lfl)


execute_process(COMMAND
    bison -o ${CMAKE_CURRENT_BINARY_DIR}/1.05_first_calculator_with_bison.c ${CMAKE_CURRENT_SOURCE_DIR}/1.05_first_calculator_with_bison.y)


add_subdirectory(1.06)
