# CMakeLists.txt for goblincamp
# TODO: blame

cmake_minimum_required (VERSION 3.12)

# TODO: configure depending on OS
set (CMAKE_INSTALL_PREFIX "./pkg/usr")

project (GOBLINCAMP)
set (GOBLINCAMP_VERSION_MAJOR 0)
set (GOBLINCAMP_VERSION_MINOR 22)

# The game and its bundled Python extension modules require Python 2.7.
find_package (Python2 2.7 REQUIRED COMPONENTS Development)
find_package (ZLIB REQUIRED)

# TODO: configure version here, use in source
configure_file (
  "${GOBLINCAMP_SOURCE_DIR}/version.hpp.in"
  "${GOBLINCAMP_BINARY_DIR}/version.hpp"
  )

# add so that we will find version.hpp
#include_directories ("${PROJECT_BINARY_DIR}")

#install (FILES "${GOBLICAMP_BINARY_DIR}/version.hpp"
#         DESTINATION include)

# TODO: find out if these can be sourced from system
add_subdirectory (vendor/python-modules)

# main source tree
add_subdirectory (src)

# add static files to distribution
install (DIRECTORY lib DESTINATION share/goblincamp)
install (FILES terminal.png DESTINATION share/goblincamp)
