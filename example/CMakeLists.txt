cmake_minimum_required(VERSION 3.28...3.29)

project(cmake-init-modulesExamples CXX)

include(../cmake/folders.cmake)

if(PROJECT_IS_TOP_LEVEL)
  # Neither of these two are technically needed, but they make the expectation clear
  set(CMAKE_CXX_STANDARD 23)
  set(CMAKE_CXX_EXTENSIONS FALSE)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

  find_package(cmake-init-modules 0.1 REQUIRED)
  find_package(my_package 0.1 REQUIRED)
  enable_testing()
endif()

add_executable(app main.cpp)
target_link_libraries(app PRIVATE Algo)
add_test(NAME app COMMAND app)

# return()

##################################################

add_custom_target(run-examples)

function(add_example NAME)
  add_executable("${NAME}" "${NAME}.cpp")
  target_link_libraries("${NAME}" PRIVATE cmake-init-modules::cmake-init-modules)
  target_compile_features("${NAME}" PRIVATE cxx_std_23)
  add_custom_target("run_${NAME}" COMMAND "${NAME}" VERBATIM)
  add_dependencies("run_${NAME}" "${NAME}")
  add_dependencies(run-examples "run_${NAME}")
  add_test(NAME ${NAME} COMMAND ${NAME})
endfunction()

add_example(empty_example)

add_folders(Example)
