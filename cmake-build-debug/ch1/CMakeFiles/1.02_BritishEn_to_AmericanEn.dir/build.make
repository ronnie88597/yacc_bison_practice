# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/cmp/Downloads/clion-2019.2/bin/cmake/linux/bin/cmake

# The command to remove a file.
RM = /home/cmp/Downloads/clion-2019.2/bin/cmake/linux/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/cmp/work_dir/source_code/yacc_bison_practice

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug

# Include any dependencies generated for this target.
include ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/depend.make

# Include the progress variables for this target.
include ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/progress.make

# Include the compile flags for this target's objects.
include ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/flags.make

ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.o: ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/flags.make
ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.o: ../ch1/1.02_BritishEn_to_AmericanEn.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.o"
	cd /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1 && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.o   -c /home/cmp/work_dir/source_code/yacc_bison_practice/ch1/1.02_BritishEn_to_AmericanEn.c

ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.i"
	cd /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1 && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/cmp/work_dir/source_code/yacc_bison_practice/ch1/1.02_BritishEn_to_AmericanEn.c > CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.i

ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.s"
	cd /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1 && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/cmp/work_dir/source_code/yacc_bison_practice/ch1/1.02_BritishEn_to_AmericanEn.c -o CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.s

# Object files for target 1.02_BritishEn_to_AmericanEn
1_02_BritishEn_to_AmericanEn_OBJECTS = \
"CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.o"

# External object files for target 1.02_BritishEn_to_AmericanEn
1_02_BritishEn_to_AmericanEn_EXTERNAL_OBJECTS =

ch1/1.02_BritishEn_to_AmericanEn: ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/1.02_BritishEn_to_AmericanEn.c.o
ch1/1.02_BritishEn_to_AmericanEn: ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/build.make
ch1/1.02_BritishEn_to_AmericanEn: ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable 1.02_BritishEn_to_AmericanEn"
	cd /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1 && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/build: ch1/1.02_BritishEn_to_AmericanEn

.PHONY : ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/build

ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/clean:
	cd /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1 && $(CMAKE_COMMAND) -P CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/cmake_clean.cmake
.PHONY : ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/clean

ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/depend:
	cd /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/cmp/work_dir/source_code/yacc_bison_practice /home/cmp/work_dir/source_code/yacc_bison_practice/ch1 /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1 /home/cmp/work_dir/source_code/yacc_bison_practice/cmake-build-debug/ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : ch1/CMakeFiles/1.02_BritishEn_to_AmericanEn.dir/depend
