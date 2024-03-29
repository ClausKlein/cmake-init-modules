cmake_minimum_required(VERSION 3.28)

project(cmake-init-modulesExamples CXX)

include(../cmake/project-is-top-level.cmake)
include(../cmake/folders.cmake)

if(PROJECT_IS_TOP_LEVEL)
  find_package(cmake-init-modules REQUIRED)
endif()

enable_testing()

add_custom_target(run-examples)

function(add_example NAME)
  add_executable("${NAME}" "${NAME}.cpp")
  target_link_libraries("${NAME}"
                        PRIVATE cmake-init-modules::cmake-init-modules)
  target_compile_features("${NAME}" PRIVATE cxx_std_20)
  add_custom_target(
    "run_${NAME}"
    COMMAND "${NAME}"
    VERBATIM)
  add_dependencies("run_${NAME}" "${NAME}")
  add_dependencies(run-examples "run_${NAME}")
  add_test(NAME ${NAME} COMMAND ${NAME})
endfunction()

add_example(empty_example)

add_folders(Example)
