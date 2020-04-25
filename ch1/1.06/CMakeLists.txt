execute_process(COMMAND
    flex -o 1.06.c ${PROJECT_SOURCE_DIR}/1.06/1.06.y)

execute_process(COMMAND
    bison -d ${PROJECT_SOURCE_DIR}/1.06/1.05_first_calculator_with_bison.y)

add_executable(1.06 ${CMAKE_BINARY_DIR}/1.06.c ${CMAKE_BINARY_DIR}/1.05_first_calculator_with_bison.tab.c)
target_include_directories(1.06 PUBLIC
    ${CMAKE_SOURCE_DIR})

target_link_libraries(1.06 PUBLIC
    -lfl)



