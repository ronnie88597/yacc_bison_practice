

#execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -perm -111 -exec rm -f {} \;) # 清除所有可执行文件
execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.h" -exec rm -f {} \;)
execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.c" -exec rm -f {} \;)
execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.cc" -exec rm -f {} \;)
execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.hh" -exec rm -f {} \;)
execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.hpp" -exec rm -f {} \;)
execute_process(COMMAND find ${CMAKE_CURRENT_BINARY_DIR} -type f -name "*.cpp" -exec rm -f {} \;)
