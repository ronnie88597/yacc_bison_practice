
cmake_minimum_required(VERSION 3.14)
project(Flex_Bison)


# --- 提交代码前，可以使用这些命令来清除flex和bison生成的文件 ---
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -perm -111 -name "[1-9].*" -exec rm -f {} \;)
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.h" -exec rm -f {} \;)
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.c" -exec rm -f {} \;)
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.cc" -exec rm -f {} \;)
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.hh" -exec rm -f {} \;)
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.hpp" -exec rm -f {} \;)
#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.cpp" -exec rm -f {} \;)
# --- 提交代码前，可以使用这些命令来清除flex和bison生成的文件 ---

add_subdirectory(ch1)
add_subdirectory(ch2)
add_subdirectory(ch3)


#include(${PROJECT_SOURCE_DIR}/cmake/clean_flex_bison_generate_code.cmake)
#execute_process(COMMAND
#    flex -o ${CMAKE_CURRENT_BINARY_DIR}/test.c ${CMAKE_CURRENT_SOURCE_DIR}/test.l)
#add_executable(test ${CMAKE_CURRENT_BINARY_DIR}/test.c)
