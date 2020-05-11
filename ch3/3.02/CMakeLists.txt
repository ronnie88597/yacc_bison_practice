include(${PROJECT_SOURCE_DIR}/cmake/clean_flex_bison_generate_code.cmake)


# 必须预先设置好包含目录，因为在3.02_create_AST_with_bison.y文件中有包含其他头文件，Bison生成代码时会校验包含的头文件是否能够找得到
include_directories(${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR})

execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_BINARY_DIR}/3.02lexer.c ${CMAKE_CURRENT_SOURCE_DIR}/3.02lexer.l)

execute_process(COMMAND
    bison -d ${CMAKE_CURRENT_SOURCE_DIR}/3.02_create_AST_with_bison.y)
execute_process(COMMAND
    mv ${CMAKE_BINARY_DIR}/3.02_create_AST_with_bison.tab.c ${CMAKE_CURRENT_BINARY_DIR})
execute_process(COMMAND
    mv ${CMAKE_BINARY_DIR}/3.02_create_AST_with_bison.tab.h ${CMAKE_CURRENT_BINARY_DIR})

add_executable(3.02_create_AST_with_bison
    ${CMAKE_CURRENT_SOURCE_DIR}/fb3.02.c
    ${CMAKE_CURRENT_BINARY_DIR}/3.02lexer.c
    ${CMAKE_CURRENT_BINARY_DIR}/3.02_create_AST_with_bison.tab.c)

