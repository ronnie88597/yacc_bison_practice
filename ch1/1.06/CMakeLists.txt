execute_process(COMMAND
    flex -o 1.06lexer.c ${CMAKE_CURRENT_SOURCE_DIR}/1.06lexer.l)

execute_process(COMMAND
    bison -d ${CMAKE_CURRENT_SOURCE_DIR}/1.06_calculator_with_bison.y)

add_executable(1.06 ${CMAKE_BINARY_DIR}/1.06lexer.c ${CMAKE_BINARY_DIR}/1.05_first_calculator_with_bison.tab.c)
target_include_directories(1.06 PUBLIC
    ${CMAKE_BINARY_DIR})

target_link_libraries(1.06 PUBLIC
    -lfl)



