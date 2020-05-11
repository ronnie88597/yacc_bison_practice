include(${PROJECT_SOURCE_DIR}/cmake/clean_flex_bison_generate_code.cmake)

# 必须预先设置好包含目录，因为在fb3.04parser.y文件中有包含其他头文件，Bison生成代码时会校验包含的头文件是否能够找得到

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR})

execute_process(COMMAND
    flex -+ -o ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp ${CMAKE_CURRENT_SOURCE_DIR}/lexer.l)

execute_process(COMMAND
    bison -o ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp ${CMAKE_CURRENT_SOURCE_DIR}/parser.y)


add_executable(3.04
    ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/driver.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

target_link_libraries(3.04 PUBLIC
    -lm)
