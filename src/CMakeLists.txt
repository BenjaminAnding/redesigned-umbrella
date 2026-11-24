# globbing sources can be dangerous, but let's assert there are no stray
# source files in the tree.
file(GLOB gc_src . *.cpp data/*.cpp scripting/*.cpp scripting/_gcampapi/*.cpp UI/*.cpp)
file(GLOB gc_render_src . tileRenderer/*.cpp tileRenderer/sdl/*.cpp)

set (Boost_USE_MULTITHREAD ON)
find_package (Boost COMPONENTS date_time filesystem iostreams python random serialization system thread REQUIRED)
find_package (PNG REQUIRED)
find_package (OpenGL REQUIRED)
find_package (Threads REQUIRED)

if (WIN32)
  file(GLOB gc_platform_src platform/windows/*.cpp)
else ()
  file(GLOB gc_platform_src platform/unix/*.cpp platform/linux/*.cpp)
endif ()

if (WIN32)
  add_executable (goblincamp WIN32 ${gc_src} ${gc_platform_src} ${gc_render_src})
else ()
  add_executable (goblincamp ${gc_src} ${gc_platform_src} ${gc_render_src})
endif ()

find_path (SDL_INCLUDE_DIR SDL.h PATH_SUFFIXES SDL)
find_library (SDL_LIBRARY NAMES SDL SDL-1.2)
find_library (SDL_IMAGE_LIBRARY NAMES SDL_image SDL_image-1.2)
find_path (TCOD_INCLUDE_DIR libtcod.hpp PATH_SUFFIXES libtcod)
find_library (TCOD_LIBRARY NAMES tcod libtcod)

if (NOT SDL_INCLUDE_DIR OR NOT SDL_LIBRARY OR NOT SDL_IMAGE_LIBRARY)
  message (FATAL_ERROR "SDL 1.2 and SDL_image 1.2 headers and libraries are required")
endif ()
if (NOT TCOD_INCLUDE_DIR OR NOT TCOD_LIBRARY)
  message (FATAL_ERROR "libtcod headers and library are required")
endif ()

include_directories (
  ${GOBLINCAMP_SOURCE_DIR}/include
  ${GOBLINCAMP_SOURCE_DIR}/vendor/python-modules
  ${GOBLINCAMP_SOURCE_DIR}
  ${SDL_INCLUDE_DIR}
  ${TCOD_INCLUDE_DIR}
  ${Python2_INCLUDE_DIRS}
)

include_directories (${Boost_INCLUDE_DIRS})

target_link_libraries (
  goblincamp
  ${Boost_LIBRARIES}
  Python2::Python
  PNG::PNG
  ZLIB::ZLIB
  ${SDL_LIBRARY}
  ${SDL_IMAGE_LIBRARY}
  ${TCOD_LIBRARY}
  python-modules
  OpenGL::GL
  Threads::Threads
)

if (WIN32)
  target_compile_definitions (goblincamp PRIVATE WINDOWS)
  target_compile_definitions (goblincamp PRIVATE $<$<CONFIG:Debug>:DEBUG> $<$<CONFIG:Debug>:GC_REDIRECT_STREAMS>)
  target_link_libraries (goblincamp dbghelp shell32 shlwapi)
endif ()

target_compile_definitions (goblincamp PRIVATE BOOST_BUILD_PCH_ENABLED)
set_target_properties (goblincamp PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED ON CXX_EXTENSIONS ON)
if (MSVC)
  target_compile_options (goblincamp PRIVATE /W3)
else ()
  target_compile_options (goblincamp PRIVATE -Wall)
endif ()

# add the install targets
install (TARGETS goblincamp DESTINATION bin)
