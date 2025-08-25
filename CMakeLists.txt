cmake_minimum_required(VERSION 3.25)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
include(identity)

project(${PROJECT_NAME} VERSION ${PROJECT_VERSION} LANGUAGES C)

option("QVM_TOOLS_PATH" "Paths to your Quake Virtual Machine compiling tools" "")

option(BUILD_GAME_LIBRARIES "Build game module libraries" ON)
option(BUILD_GAME_QVMS "Build game module qvms" OFF)

option(USE_ARCHLESS_FILENAMES "Don't include the architecture in binary filenames" OFF)

# Release build by default, set externally if you want something else
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_SHARED_LIBRARY_PREFIX "")

if(NOT PRODUCT_VERSION)
    set(PRODUCT_VERSION "${CMAKE_PROJECT_VERSION}")

    if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
        execute_process(
            COMMAND git show -s --pretty=format:%h
            WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
            OUTPUT_VARIABLE GIT_REV
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_QUIET)

        if(GIT_REV)
            set(PRODUCT_VERSION "${PRODUCT_VERSION}_g${GIT_REV}")
        endif()
    endif()
endif()

add_compile_definitions(PRODUCT_VERSION="${PRODUCT_VERSION}")

# For CI to read from
file(GENERATE OUTPUT ${CMAKE_BINARY_DIR}/version.txt CONTENT ${PRODUCT_VERSION})

set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/code)

include(compilers/all)
include(platforms/all)

include(basegame)
