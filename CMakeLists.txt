cmake_minimum_required(VERSION 3.28.4...3.29)

include(cmake/prelude.cmake)

project(cxx_modules_example VERSION 0.1.0 LANGUAGES CXX)

# This property setting also needs to be consistent between the
# installed shared library and its consumer, otherwise most
# toolchains will once again reject the consumer’s generated BMI.
set(CMAKE_CXX_EXTENSIONS FALSE)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN TRUE)

add_library(Algo SHARED)

#########################################################################
# cmake-format: off
target_sources(Algo
    PRIVATE
        algo-impl.cpp
    PUBLIC
        FILE_SET CXX_MODULES
        FILES
            algo-interface.cppm
)
target_link_libraries(Algo PRIVATE fmt::fmt)

# CMake requires the language standard to be specified as compile feature
# when a target provides C++20 modules and the target will be installed
target_compile_features(Algo PUBLIC cxx_std_20)

include(GenerateExportHeader)
generate_export_header(Algo)
target_sources(Algo
    PUBLIC
        FILE_SET HEADERS
        BASE_DIRS ${CMAKE_CURRENT_BINARY_DIR}
        FILES
            ${CMAKE_CURRENT_BINARY_DIR}/algo_export.h
)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

write_basic_package_version_file("my_package-config-version.cmake" COMPATIBILITY SameMajorVersion)

install(TARGETS Algo
    EXPORT my_package-targets
    # ... a few details omitted, see the "Deep CMake For Library Authors" talk
    FILE_SET CXX_MODULES
        # There's currently no convention for this location, see discussion below
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_package/src
    FILE_SET HEADERS
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}   # Same as default, could be omitted
    INCLUDES
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
install(EXPORT my_package-targets
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_package
    CXX_MODULES_DIRECTORY .
)
install(
    FILES "${PROJECT_BINARY_DIR}/my_package-config-version.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_package
)
# The following file includes the my_package-targets.cmake file
install(FILES cmake/my_package-config.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/my_package
)

# cmake-format: on
#########################################################################

# enable_testing()
# add_subdirectory(example)
# return()

##################################################

# project(
#   cmake-init-modules
#   VERSION 0.1.0
#   DESCRIPTION "Short description"
#   HOMEPAGE_URL "https://example.com/"
#   LANGUAGES CXX)

include(cmake/variables.cmake)

# ---- Declare library ----

add_library(cmake-init-modules_cmake-init-modules source/cmake-init-modules.cpp)
add_library(cmake-init-modules::cmake-init-modules ALIAS cmake-init-modules_cmake-init-modules)

include(GenerateExportHeader)
generate_export_header(
  cmake-init-modules_cmake-init-modules
  BASE_NAME
  cmake-init-modules
  EXPORT_FILE_NAME
  export/cmake-init-modules/cmake-init-modules_export.hpp
  CUSTOM_CONTENT_FROM_VARIABLE
  pragma_suppress_c4251
)

# cmake-format: off
target_sources(
  cmake-init-modules_cmake-init-modules
  PUBLIC FILE_SET HEADERS
         BASE_DIRS
            ${PROJECT_BINARY_DIR}/export
            ${PROJECT_SOURCE_DIR}/include
         FILES
            include/cmake-init-modules/cmake-init-modules.hpp
            ${PROJECT_BINARY_DIR}/export/cmake-init-modules/cmake-init-modules_export.hpp
)
# cmake-format: on

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(
    cmake-init-modules_cmake-init-modules PUBLIC CMAKE_INIT_MODULES_STATIC_DEFINE
  )
endif()

set_target_properties(
  cmake-init-modules_cmake-init-modules
  PROPERTIES CXX_VISIBILITY_PRESET hidden
             VISIBILITY_INLINES_HIDDEN YES
             VERSION "${PROJECT_VERSION}"
             SOVERSION "${PROJECT_VERSION_MAJOR}"
             EXPORT_NAME cmake-init-modules
             OUTPUT_NAME cmake-init-modules
)

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
  option(BUILD_EXAMPLES "Build examples tree." "${cmake-init-modules_DEVELOPER_MODE}")
  if(BUILD_EXAMPLES)
    add_subdirectory(example)
  endif()
endif()

# ---- Developer mode ----

if(NOT cmake-init-modules_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(AUTHOR_WARNING "Developer mode is intended for developers of cmake-init-modules")
endif()

include(cmake/dev-mode.cmake)
