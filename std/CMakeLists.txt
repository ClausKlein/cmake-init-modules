cmake_minimum_required(VERSION 3.30...3.31)

#
# Set language version used
#
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
# Currently CMake requires extensions enabled when using import std.
# https://gitlab.kitware.com/cmake/cmake/-/issues/25916
# https://gitlab.kitware.com/cmake/cmake/-/issues/25539
set(CMAKE_CXX_EXTENSIONS ON)

#
# see https://gitlab.kitware.com/cmake/cmake/-/issues/25965#note_1523575
# and https://www.kitware.com/import-std-in-cmake-3-30/
#
if("${CMAKE_GENERATOR}" STREQUAL "Visual Studio 17 2022")
  # This can be done before or after project() on MSVC
  # It works regardless of CMAKE_EXPERIMENTAL_CXX_IMPORT_STD
  set(CMAKE_CXX_SCAN_FOR_MODULES ON)

  # This does not seem to work on MSVC under any circumstances
  # set(CMAKE_CXX_MODULE_STD ON)
else()
  # This needs to be done before selecting the languages so the project() command
  # The CMAKE_EXPERIMENTAL_CXX_IMPORT_STD is required
  set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
  set(CMAKE_CXX_MODULE_STD ON)

  # Does not work regardless of value of CMAKE_EXPERIMENTAL_CXX_IMPORT_STD
  # set(CMAKE_CXX_SCAN_FOR_MODULES ON)
endif()

project("example" LANGUAGES CXX)

add_executable(main)
target_sources(main PRIVATE main.cpp)

# Make a library.
add_library(uses_std STATIC)
# Add sources.
target_sources(uses_std PRIVATE uses_std.cxx)
# Tell CMake we're using C++23 but only C++20 is needed to consume it.
target_compile_features(uses_std PRIVATE cxx_std_23 INTERFACE cxx_std_20)

# Make an executable.
add_executable(test-module)
# Note that this source is *not* allowed to `import std` as it ends up
# with only C++20 support due to the `uses_std` INTERFACE requirements.
target_sources(test-module PRIVATE main.cxx)
target_link_libraries(test-module PRIVATE uses_std)

enable_testing()
add_test(NAME test-module COMMAND test-module)
