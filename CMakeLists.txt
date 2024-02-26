cmake_minimum_required(VERSION 3.28)

include(cmake/prelude.cmake)

project(
  cmake-init-modules
  VERSION 0.1.0
  DESCRIPTION "Short description"
  HOMEPAGE_URL "https://example.com/"
  LANGUAGES CXX)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Declare library ----

add_library(cmake-init-modules_cmake-init-modules source/cmake-init-modules.cpp)
add_library(cmake-init-modules::cmake-init-modules ALIAS
            cmake-init-modules_cmake-init-modules)

include(GenerateExportHeader)
generate_export_header(
  cmake-init-modules_cmake-init-modules
  BASE_NAME
  cmake-init-modules
  EXPORT_FILE_NAME
  export/cmake-init-modules/cmake-init-modules_export.hpp
  CUSTOM_CONTENT_FROM_VARIABLE
  pragma_suppress_c4251)

configure_file(include/cmake-init-modules/cmake-init-modules.hpp
               export/cmake-init-modules/cmake-init-modules.hpp COPYONLY)

# cmake-format: off
target_sources(
  cmake-init-modules_cmake-init-modules
  PUBLIC FILE_SET HEADERS
         BASE_DIRS
            ${PROJECT_BINARY_DIR}/export
         FILES
            ${PROJECT_BINARY_DIR}/export/cmake-init-modules/cmake-init-modules.hpp
            ${PROJECT_BINARY_DIR}/export/cmake-init-modules/cmake-init-modules_export.hpp
)
# cmake-format: on

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(cmake-init-modules_cmake-init-modules
                             PUBLIC CMAKE_INIT_MODULES_STATIC_DEFINE)
endif()

set_target_properties(
  cmake-init-modules_cmake-init-modules
  PROPERTIES CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES
             VERSION "${PROJECT_VERSION}"
             SOVERSION "${PROJECT_VERSION_MAJOR}"
             EXPORT_NAME cmake-init-modules
             OUTPUT_NAME cmake-init-modules)

# target_include_directories( cmake-init-modules_cmake-init-modules
# ${warning_guard} PUBLIC "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>" )
#
# target_include_directories( cmake-init-modules_cmake-init-modules SYSTEM
# PUBLIC "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/export>" )

target_compile_features(cmake-init-modules_cmake-init-modules PUBLIC cxx_std_20)

find_package(fmt REQUIRED)
target_link_libraries(cmake-init-modules_cmake-init-modules PRIVATE fmt::fmt)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Examples ----
enable_testing()

if(PROJECT_IS_TOP_LEVEL)
  option(BUILD_EXAMPLES "Build examples tree."
         "${cmake-init-modules_DEVELOPER_MODE}")
  if(BUILD_EXAMPLES)
    add_subdirectory(example)
  endif()
endif()

# ---- Developer mode ----

if(NOT cmake-init-modules_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
    AUTHOR_WARNING
      "Developer mode is intended for developers of cmake-init-modules")
endif()

include(cmake/dev-mode.cmake)
