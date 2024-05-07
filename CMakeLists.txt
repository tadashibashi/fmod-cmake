cmake_minimum_required(VERSION 3.23)
project(fmod_cmake)
# Pass in FMOD_VERSION, if you only want to use FMOD Core.
# Pass in FMOD_STUDIO_VERSION if you want to use the FMOD Studio API,
# which will automatically include Core with it.

if (NOT FMOD_VERSION AND NOT FMOD_STUDIO_VERSION)
    set(FMOD_VERSION 2.02.21)
endif()

if (FMOD_STUDIO_VERSION)
    set(FMOD_VERSION ${FMOD_STUDIO_VERSION})
endif()

if (NOT DEFINED FMOD_CMAKE_EXAMPLE)
    set (FMOD_CMAKE_EXAMPLE "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}" CACHE BOOL
        "Auto add example executable if this is the root CMake directory" FORCE)
endif()

add_subdirectory(fmod)

if (FMOD_CMAKE_EXAMPLE)
    add_subdirectory(example)
endif()