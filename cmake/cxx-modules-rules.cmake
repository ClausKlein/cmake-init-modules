include_guard()

# Use modules?
set(ALGO_USE_MODULES OFF)

set(CMAKE_SKIP_TEST_ALL_DEPENDENCY OFF)
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
if(NOT DEFINED CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 23)
    set(CMAKE_CXX_EXTENSIONS ON)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

if(CMAKE_GENERATOR STREQUAL "Ninja")
    if(
        CMAKE_CXX_COMPILER_ID STREQUAL "Clang"
        AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 19.0
    )
        set(ALGO_USE_MODULES ON)
        string(APPEND CMAKE_CXX_MODULE_MAP_FLAG " -fmodules-reduced-bmi")

        add_compile_options($ENV{CXXFLAGS})
        add_link_options($ENV{CXXFLAGS})
    elseif(
        CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
        AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 15.0
    )
        set(ALGO_USE_MODULES ON)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set(ALGO_USE_MODULES ON)
    endif()
endif()

if(CMAKE_CXX_STDLIB_MODULES_JSON)
    message(
        STATUS
        "CMAKE_CXX_STDLIB_MODULES_JSON=${CMAKE_CXX_STDLIB_MODULES_JSON}"
    )
endif()

# Tell CMake that we explicitly want `import std`.
# This will initialize the property on all targets declared after this to 1
message(STATUS "CMAKE_CXX_COMPILER_IMPORT_STD=${CMAKE_CXX_COMPILER_IMPORT_STD}")
if(${CMAKE_CXX_STANDARD} IN_LIST CMAKE_CXX_COMPILER_IMPORT_STD)
    set(CMAKE_CXX_MODULE_STD ON)
    message(STATUS "CMAKE_CXX_MODULE_STD=${CMAKE_CXX_MODULE_STD}")
endif()

message(STATUS "ALGO_USE_MODULES=${ALGO_USE_MODULES}")
message(
    STATUS
    "CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES=${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}"
)

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
