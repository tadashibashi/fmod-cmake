project(fmod_cmake_test)

set (CMAKE_CXX_STANDARD 11)

add_executable(fmod_cmake_test fmod_cmake_test.cpp)
target_link_libraries(fmod_cmake_test fmod)

if (NOT EMSCRIPTEN)
    include(FetchContent)

    FetchContent_Declare(SDL2
        GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
        GIT_TAG        fb1497566c5a05e2babdcf45ef0ab5c7cca2c4ae
    )

    FetchContent_MakeAvailable(SDL2)

    target_link_libraries(fmod_cmake_test SDL2::SDL2 SDL2::SDL2main)
endif()

if (EMSCRIPTEN)
    set_target_properties(fmod_cmake_test PROPERTIES
        SUFFIX .html
    )
    target_link_options(fmod_cmake_test PRIVATE
        -sUSE_SDL=2
        --preload-file ${CMAKE_CURRENT_SOURCE_DIR}/../assets@assets
    )
    target_compile_options(fmod_cmake_test PRIVATE -sUSE_SDL=2)
else()
    if (NOT EXISTS ${CURRENT_BINARY_DIR}/assets)
    execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink
        ${CMAKE_CURRENT_SOURCE_DIR}/../assets
        ${CMAKE_CURRENT_BINARY_DIR}/assets)
    endif()
endif()
