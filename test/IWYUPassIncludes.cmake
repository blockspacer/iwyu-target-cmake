# /tests/IWYUPassIncludes.cmake
# Sets up a target and runs include-what-you-use on it. Pass some
# includes.
#
# See LICENCE.md for Copyright information

include (${IWYU_CMAKE_TESTS_DIRECTORY}/CMakeUnit.cmake)
include (${IWYU_CMAKE_DIRECTORY}/IncludeWhatYouUse.cmake)

_validate_include_what_you_use (CONTINUE)

set (HEADER_FILE ${CMAKE_CURRENT_BINARY_DIR}/internal/Header.h)
set (HEADER_FILE_CONTENTS
     "#ifndef HEADER_H\n"
     "#define HEADER_H\n"
     "struct A\n"
     "{\n"
     "    int i\;\n"
     "}\;\n"
     "#endif")

set (SOURCE_FILE ${CMAKE_CURRENT_BINARY_DIR}/Source.cpp)
set (SOURCE_FILE_CONTENTS
     "#include <Header.h>\n"
     "int main (void)\n"
     "{\n"
     "    struct A a = {3}\;\n"
     "    return a.i\;\n"
     "}\n")

file (WRITE ${SOURCE_FILE} ${SOURCE_FILE_CONTENTS})
file (WRITE ${HEADER_FILE} ${HEADER_FILE_CONTENTS})

set (EXECUTABLE executable)
include_directories (${CMAKE_CURRENT_BINARY_DIR}/internal)
include_directories (${CMAKE_CURRENT_BINARY_DIR}/external)
add_executable (${EXECUTABLE}
                ${SOURCE_FILE}
                ${HEADER_FILE})

iwyu_target_sources (${EXECUTABLE}
                     INTERNAL_INCLUDE_DIRS
                     ${CMAKE_CURRENT_BINARY_DIR}
                     INTERNAL_INCLUDE_DIRS
                     ${CMAKE_CURRENT_BINARY_DIR}/internal
                     EXTERNAL_INCLUDE_DIRS
                     ${CMAKE_CURRENT_BINARY_DIR}/external)