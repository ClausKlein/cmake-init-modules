cmake_minimum_required(VERSION 3.28...3.29)

project(cmake-init-modulesExamples CXX)

include(../cmake/folders.cmake)

if(PROJECT_IS_TOP_LEVEL)
  find_package(cmake-init-modules REQUIRED)
  find_package(my_package REQUIRED)
  enable_testing()
endif()

# Neither of these two are technically needed, but they make the expectation clear
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_EXTENSIONS FALSE)

add_executable(app main.cpp)
target_link_libraries(app PRIVATE Algo)
add_test(NAME app COMMAND app)

# return()

##################################################

add_custom_target(run-examples)

function(add_example NAME)
  add_executable("${NAME}" "${NAME}.cpp")
  target_link_libraries("${NAME}" PRIVATE cmake-init-modules::cmake-init-modules)
  target_compile_features("${NAME}" PRIVATE cxx_std_20)
  add_custom_target("run_${NAME}" COMMAND "${NAME}" VERBATIM)
  add_dependencies("run_${NAME}" "${NAME}")
  add_dependencies(run-examples "run_${NAME}")
  add_test(NAME ${NAME} COMMAND ${NAME})
endfunction()

add_example(empty_example)

add_folders(Example)
