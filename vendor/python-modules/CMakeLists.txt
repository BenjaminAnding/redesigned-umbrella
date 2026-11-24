file (GLOB pm_src . *.c)
add_library (python-modules ${pm_src})
target_include_directories (python-modules PRIVATE ${Python2_INCLUDE_DIRS})
target_link_libraries (python-modules PRIVATE ZLIB::ZLIB)
