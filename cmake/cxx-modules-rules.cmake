include_guard()

# Use modules?
unset(ALGO_USE_MODULES)

set(CMAKE_SKIP_TEST_ALL_DEPENDENCY FALSE)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Ensure non-empty default build type for single-config
get_property(isMultiConfig GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT isMultiConfig)
  set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
endif()
set(CMAKE_DEBUG_POSTFIX _debug)

# This property setting also needs to be consistent between the
# installed shared library and its consumer, otherwise most
# toolchains will once again reject the consumer's generated BMI.
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_GENERATOR STREQUAL "Ninja")
  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL
                                                20.0
  )
    set(ALGO_USE_MODULES TRUE)
    string(APPEND CMAKE_CXX_MODULE_MAP_FLAG " -fmodules-reduced-bmi")

    # see https://releases.llvm.org/20.0.0/projects/libcxx/docs/ReleaseNotes.html
    # Always use libc++
    if(APPLE)
      execute_process(OUTPUT_VARIABLE LLVM_PREFIX COMMAND brew --prefix llvm@20 COMMAND_ECHO STDOUT)
      string(STRIP ${LLVM_PREFIX} LLVM_PREFIX)
      file(REAL_PATH ${LLVM_PREFIX} LLVM_ROOT)
      set(LLVM_ROOT ${LLVM_ROOT} CACHE PATH "")

      message(STATUS "LLVM_ROOT=${LLVM_ROOT}")
      add_link_options(-L${LLVM_ROOT}/lib/c++)
      include_directories(SYSTEM ${LLVM_ROOT}/include)
    endif()

    add_compile_options(-stdlib=libc++)
    add_link_options(-stdlib=libc++)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL
                                                  15.0
  )
    set(ALGO_USE_MODULES TRUE)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(ALGO_USE_MODULES TRUE)
  endif()
endif()

message(STATUS "ALGO_USE_MODULES=${ALGO_USE_MODULES}")
message(STATUS "CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES=${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}")

set(stageDir ${CMAKE_CURRENT_BINARY_DIR}/stagedir)
include(GNUInstallDirs)
if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${stageDir}/${CMAKE_INSTALL_BINDIR})
endif()
if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${stageDir}/${CMAKE_INSTALL_LIBDIR})
endif()
if(NOT CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${stageDir}/${CMAKE_INSTALL_LIBDIR})
endif()
