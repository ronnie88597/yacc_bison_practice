include(${PROJECT_SOURCE_DIR}/cmake/clean_flex_bison_generate_code.cmake)

execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_BINARY_DIR}/1.06lexer.c
    ${CMAKE_CURRENT_SOURCE_DIR}/1.06lexer.l)

execute_process(COMMAND
    bison -d ${CMAKE_CURRENT_SOURCE_DIR}/1.06_calculator_with_bison.y)
execute_process(COMMAND
    mv ${CMAKE_BINARY_DIR}/1.06_calculator_with_bison.tab.c ${CMAKE_CURRENT_BINARY_DIR})
execute_process(COMMAND
    mv ${CMAKE_BINARY_DIR}/1.06_calculator_with_bison.tab.h ${CMAKE_CURRENT_BINARY_DIR})

add_executable(1.06 ${CMAKE_CURRENT_BINARY_DIR}/1.06lexer.c
    ${CMAKE_CURRENT_BINARY_DIR}/1.06_calculator_with_bison.tab.c)

target_include_directories(1.06 PUBLIC
    ${CMAKE_BINARY_DIR})

target_link_libraries(1.06 PUBLIC
    -lfl)



