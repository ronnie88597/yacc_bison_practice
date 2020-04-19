cmake_minimum_required(VERSION 3.14)
project(word_counter)

execute_process(COMMAND
    flex -o ${PROJECT_SOURCE_DIR}/word_counter.c ${PROJECT_SOURCE_DIR}/word_counter.l)

execute_process(COMMAND
    flex -o ${PROJECT_SOURCE_DIR}/BritishEn_to_AmericanEn.c ${PROJECT_SOURCE_DIR}/BritishEn_to_AmericanEn.l)

add_executable(word_counter word_counter.c)

target_link_libraries(word_counter PUBLIC
    -lfl)


add_executable(BritishEn_to_AmericanEn BritishEn_to_AmericanEn.c)

target_link_libraries(BritishEn_to_AmericanEn PUBLIC
    -lfl)