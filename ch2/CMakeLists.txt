
execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/2.01_usual_lang_lex_re.c
    ${CMAKE_CURRENT_SOURCE_DIR}/2.01_usual_lang_lex_re.l)

add_executable(2.01_usual_lang_lex_re
    2.01_usual_lang_lex_re.c)

target_link_libraries(2.01_usual_lang_lex_re PUBLIC
    -lfl)


execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/2.02_use_yyin_to_read_data_from_file.c
    ${CMAKE_CURRENT_SOURCE_DIR}/2.02_use_yyin_to_read_data_from_file.l)

add_executable(2.02_use_yyin_to_read_data_from_file
    2.02_use_yyin_to_read_data_from_file.c)


execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/2.03_read_files.c
    ${CMAKE_CURRENT_SOURCE_DIR}/2.03_read_files.l)

add_executable(2.03_read_files
    2.03_read_files.c)


execute_process(COMMAND
flex -o ${CMAKE_CURRENT_SOURCE_DIR}/2.06_include_file_and_start_state.c
    ${CMAKE_CURRENT_SOURCE_DIR}/2.06_include_file_and_start_state.l)

add_executable(2.06_include_file_and_start_state
2.06_include_file_and_start_state.c)