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
if(CMAKE_VERSION VERSION_GREATER_EQUAL 4.0)
    set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
else()
    set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
endif()
# gersemi: on

if($ENV{CXX} MATCHES "clang" OR CMAKE_CXX_COMPILER MATCHES "clang")
    # see https://releases.llvm.org/19.1.0/projects/libcxx/docs/index.html
    if(APPLE)
        # Always use libc++
        set(ENV{CXXFLAGS} -stdlib=libc++)
        message(STATUS "CXXFLAGS=-stdlib=libc++")

        execute_process(
            OUTPUT_VARIABLE LLVM_PREFIX
            COMMAND brew --prefix llvm
            COMMAND_ECHO STDOUT
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        file(REAL_PATH ${LLVM_PREFIX} LLVM_ROOT)
        set(LLVM_ROOT ${LLVM_ROOT} CACHE FILEPATH "")

        message(STATUS "LLVM_ROOT=${LLVM_ROOT}")
        add_link_options(-L${LLVM_ROOT}/lib/c++)
        include_directories(SYSTEM ${LLVM_ROOT}/include)

        if(CMAKE_VERSION VERSION_GREATER_EQUAL 4.2)
            set(CMAKE_CXX_STDLIB_MODULES_JSON
                ${LLVM_ROOT}/lib/c++/libc++.modules.json
            )
            # gersemi: off
            set(CACHE{CMAKE_CXX_STDLIB_MODULES_JSON}
                TYPE FILEPATH
                VALUE ${CMAKE_CXX_STDLIB_MODULES_JSON}
                HELP "Result of: clang++ -print-file-name=c++/libc++.modules.json"
            )
            # gersemi: on
        endif()
    endif()
endif()
