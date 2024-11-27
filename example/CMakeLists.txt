cmake_minimum_required(VERSION 3.30...3.31)

project(cmake-init-modulesExamples CXX)

if(PROJECT_IS_TOP_LEVEL)
  # Neither of these two are technically needed, but they make the expectation clear
  set(CMAKE_CXX_STANDARD 23)
  set(CMAKE_CXX_EXTENSIONS FALSE)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

  find_package(my_package 0.2 QUIET)
  if(NOT my_package_FOUND)
    message(STATUS "find_package(my_package) was NOT found, use as subproject ...")
    # test if the targets are usable if used as subproject
    add_subdirectory(.. my_package EXCLUDE_FROM_ALL)
  endif()

  enable_testing()
endif()

add_executable(app main.cpp)
target_link_libraries(app PRIVATE my_package::Algo)
add_test(NAME app-tests COMMAND app)

if(NOT PROJECT_IS_TOP_LEVEL)
  # test if the targets are findable from the source or install directory
  # cmake-format: off
  add_test(NAME find-package-test
    COMMAND ${CMAKE_CTEST_COMMAND}
      --verbose
      --output-on-failure
      -C $<CONFIG>
      --build-and-test
          "${CMAKE_CURRENT_SOURCE_DIR}"
          "${CMAKE_CURRENT_BINARY_DIR}/find-package-test"
      --build-generator ${CMAKE_GENERATOR}
      --build-makeprogram ${CMAKE_MAKE_PROGRAM}
      --build-options
          "-DCMAKE_BUILD_TYPE=$<CONFIG>"
          "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
          "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
          "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
          # FIXME: needed for multi-type generators "--config $<CONFIG>"
  )
  # cmake-format: on
endif()

##################################################
return() # NOTE: XXX
##################################################

include(../cmake/folders.cmake)

if(PROJECT_IS_TOP_LEVEL)
  find_package(cmake-init-modules 0.1 REQUIRED)
endif()

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
