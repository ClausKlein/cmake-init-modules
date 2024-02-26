cmake_minimum_required(VERSION 3.14)

project(cmake-init-modulesTests LANGUAGES CXX)

include(../cmake/project-is-top-level.cmake)
include(../cmake/folders.cmake)

# ---- Dependencies ----

if(PROJECT_IS_TOP_LEVEL)
  find_package(cmake-init-modules REQUIRED)
  enable_testing()
endif()

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Tests ----

add_executable(cmake-init-modules_test source/cmake-init-modules_test.cpp)
target_link_libraries(
  cmake-init-modules_test PRIVATE cmake-init-modules::cmake-init-modules
                                  Catch2::Catch2WithMain)
target_compile_features(cmake-init-modules_test PRIVATE cxx_std_20)

catch_discover_tests(cmake-init-modules_test)

# ---- End-of-file commands ----

add_folders(Test)
