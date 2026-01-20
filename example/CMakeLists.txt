cmake_minimum_required(VERSION 3.30...4.2)

include(../cmake/prelude.cmake)

project(cmake-init-modulesExamples LANGUAGES CXX)

if(PROJECT_IS_TOP_LEVEL)
    include(../cmake/cxx-modules-rules.cmake)

    find_package(my_package 0.2.0 EXACT REQUIRED)

    # if(NOT my_package_FOUND)
    #   message(STATUS "find_package(my_package) was NOT found, use as subproject ...")
    #   # test if the targets are usable if used as subproject
    #   add_subdirectory(.. my_package EXCLUDE_FROM_ALL)
    # endif()

    enable_testing()
endif()

if(ALGO_USE_MODULES)
    add_executable(app main.cpp)
    target_link_libraries(app PRIVATE my_package::Algo)
    add_test(NAME app-tests COMMAND app)
else()
    message(FATAL_ERROR "Missing support for CXX_MODULES!")
endif()

if(NOT PROJECT_IS_TOP_LEVEL AND CMAKE_BUILD_TYPE STREQUAL Release)
    # test if the targets are usable from the install directory
    add_test(
        NAME install-to-stagedir
        COMMAND
            ${CMAKE_COMMAND} --install ${CMAKE_BINARY_DIR} --prefix
            ${CMAKE_BINARY_DIR}/stagedir
    )

    # test if the targets are findable from the source or install directory
    # gersemi: off
    add_test(
        NAME find-package-test
        COMMAND
            ${CMAKE_CTEST_COMMAND} -C $<CONFIG>
            --build-and-test #
            "${CMAKE_CURRENT_SOURCE_DIR}"
            "${CMAKE_CURRENT_BINARY_DIR}/find-package-test"
            --build-generator ${CMAKE_GENERATOR} #
            --build-makeprogram ${CMAKE_MAKE_PROGRAM} #
            --build-options #
            "-D CMAKE_BUILD_TYPE=$<CONFIG>"
            "-D CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
            "-D CMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}"
            "-D CMAKE_CXX_STDLIB_MODULES_JSON=${CMAKE_CXX_STDLIB_MODULES_JSON}"
            "-D CMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
            "-D CMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/stagedir"
    )
    # gersemi: on
endif()

if(NOT ALGO_USE_MODULES)
    include(../cmake/folders.cmake)

    if(PROJECT_IS_TOP_LEVEL)
        find_package(cmake-init-modules 0.2.0 EXACT REQUIRED)
    endif()

    add_custom_target(run-examples)

    function(add_example NAME)
        add_executable("${NAME}" "${NAME}.cpp")
        target_link_libraries(
            "${NAME}"
            PRIVATE cmake-init-modules::cmake-init-modules
        )
        target_compile_features("${NAME}" PRIVATE cxx_std_23)
        add_custom_target("run_${NAME}" COMMAND "${NAME}" VERBATIM)
        add_dependencies("run_${NAME}" "${NAME}")
        add_dependencies(run-examples "run_${NAME}")
        add_test(NAME ${NAME} COMMAND ${NAME})
    endfunction()

    # empty_example.cpp
    add_example(empty_example)

    add_folders(Example)
endif()
