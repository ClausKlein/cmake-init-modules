# ---- In-source guard ----
include_guard()

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds are not supported. "
        "Please read the BUILDING document before trying to build this project. "
        "You may need to delete 'CMakeCache.txt' and 'CMakeFiles/' first."
    )
endif()

# gersemi: off
if(CMAKE_VERSION VERSION_EQUAL 4.2)
    set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
endif()
# gersemi: on

if($ENV{CXX} MATCHES "clang" OR CMAKE_CXX_COMPILER MATCHES "clang")
    # see https://releases.llvm.org/19.1.0/projects/libcxx/docs/index.html
    # Always use libc++
    set(ENV{CXXFLAGS} -stdlib=libc++)
    message(STATUS "CXXFLAGS=-stdlib=libc++")

    if(APPLE)
        execute_process(
            OUTPUT_VARIABLE LLVM_PREFIX
            COMMAND brew --prefix llvm
            COMMAND_ECHO STDOUT
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        file(REAL_PATH ${LLVM_PREFIX} LLVM_DIR)
        set(LLVM_DIR ${LLVM_DIR} CACHE FILEPATH "")

        message(STATUS "LLVM_DIR=${LLVM_DIR}")
        add_link_options(-L${LLVM_DIR}/lib/c++)
        include_directories(SYSTEM ${LLVM_DIR}/include)

        set(CMAKE_CXX_STDLIB_MODULES_JSON
            ${LLVM_DIR}/lib/c++/libc++.modules.json
        )
    elseif(LINUX AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 21.0)
        execute_process(
            OUTPUT_VARIABLE LLVM_MODULES
            COMMAND clang++ -print-file-name=c++/libc++.modules.json
            COMMAND_ECHO STDOUT
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(NOT CMAKE_CXX_STDLIB_MODULES_JSON)
            set(CMAKE_CXX_STDLIB_MODULES_JSON ${LLVM_MODULES})
        endif()
        message(
            STATUS
            "CMAKE_CXX_STDLIB_MODULES_JSON=${CMAKE_CXX_STDLIB_MODULES_JSON}"
        )
    endif()

    if(EXISTS ${CMAKE_CXX_STDLIB_MODULES_JSON})
        # gersemi: off
        set(CACHE{CMAKE_CXX_STDLIB_MODULES_JSON}
            TYPE FILEPATH
            HELP "Result of: clang++ -print-file-name=c++/libc++.modules.json"
            VALUE ${CMAKE_CXX_STDLIB_MODULES_JSON}
        )
        # gersemi: on
    endif()
endif()
