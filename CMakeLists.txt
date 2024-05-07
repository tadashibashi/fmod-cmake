cmake_minimum_required(VERSION 3.23)
project(fmod_cmake)

set(FMOD_CMAKE_ROOT ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "" FORCE)

# ===== CMake Modules =====
set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake;${CMAKE_MODULE_PATH}")

# Provide functions
include(fmod_copy_dlls)

# ===== FMOD =====
if (NOT FMOD_VERSION)
    set(FMOD_VERSION 2.02.21)
endif()

add_subdirectory(fmod)

# ===== Example project =====
if (NOT DEFINED FMOD_CMAKE_EXAMPLE)
    set (FMOD_CMAKE_EXAMPLE "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}" CACHE BOOL
        "Auto add example executable if this is the root CMake directory" FORCE)
endif()

if (FMOD_CMAKE_EXAMPLE)
    add_subdirectory(example)
endif()

