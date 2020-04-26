
execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/2.01_usual_lang_lex_re.c
    ${CMAKE_CURRENT_SOURCE_DIR}/2.01_usual_lang_lex_re.y)

add_executable(2.01_usual_lang_lex_re 2.01_usual_lang_lex_re.c)

target_link_libraries(2.01_usual_lang_lex_re PUBLIC
    -lfl)


execute_process(COMMAND
    flex -o ${CMAKE_CURRENT_SOURCE_DIR}/2.02_use_yyin_to_read_data_from_file.c
    ${CMAKE_CURRENT_SOURCE_DIR}/2.02_use_yyin_to_read_data_from_file.y)

add_executable(2.02_use_yyin_to_read_data_from_file 2.02_use_yyin_to_read_data_from_file.c)

