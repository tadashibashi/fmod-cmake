
if (NOT FMOD_VERSION)
    message(WARNING "FMOD_VERSION was not specified, add_library ignored.")
    return()
endif()

string(TOUPPER ${CMAKE_BUILD_TYPE} BUILD_TYPE_UPPER)

if (BUILD_TYPE_UPPER MATCHES "DEBUG" OR BUILD_TYPE_UPPER MATCHES "RELWITHDEBINFO")
    set(FMOD_LIB_TYPE "L")
else()
    set(FMOD_LIB_TYPE "")
endif()

# Detect platform based on host if user didn't provide it
if (NOT FMOD_PLATFORM)
    if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")

        set(FMOD_PLATFORM macos) # FMOD Mac libs combine x86_64 and arm64 architectures into a universal lib

        set(FMOD_LIB_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/${FMOD_VERSION}/lib/${FMOD_PLATFORM})
        set(FMOD_LIBS
            ${FMOD_LIB_ROOT}/libfmod${FMOD_LIB_TYPE}.dylib
        )
        set(FMOD_STUDIO_LIBS
            ${FMOD_LIB_ROOT}/libfmodstudio${FMOD_LIB_TYPE}.dylib
        )

    elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS")

        message(FATAL_ERROR "iOS platform detection not implemented yet")
        set (FMOD_PLATFORM ios)

    elseif(WIN32)

        if (NOT MSVC) # FMOD only provides MSVC builds across all archs
            message(FATAL_ERROR "Non-MSVC Windows compilers not supported")
        endif()

        if (CMAKE_SYSTEM_PROCESSOR MATCHES "(x86)|(X86)|(amd64)|(AMD64)")
            if (CMAKE_SIZEOF_VOID_P EQUAL 4)
                set (FMOD_PLATFORM windows-x86)
            else()
                set (FMOD_PLATFORM windows-amd64)
            endif()
        elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(arm64)|(ARM64)")
            set (FMOD_PLATFORM windows-arm64)
        else()
            message(FATAL_ERROR "Windows with architecture ${CMAKE_SYSTEM_PROCESSOR} is not supported")
        endif()

        set(FMOD_LIB_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/${FMOD_VERSION}/lib/${FMOD_PLATFORM})
        set(FMOD_LIBS
            ${FMOD_LIB_ROOT}/libfmod${FMOD_LIB_TYPE}_vc.lib
        )
        set(FMOD_STUDIO_LIBS
            ${FMOD_LIB_ROOT}/libfmodstudio${FMOD_LIB_TYPE}_vc.lib
        )

    elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")

        message(WARNING "Linux is not tested and supported yet")

        if (CMAKE_SYSTEM_PROCESSOR MATCHES "(x86)|(X86)|(amd64)|(AMD64)|(unknown)")
            if (CMAKE_SIZEOF_VOID_P EQUAL 4)
                set (FMOD_PLATFORM linux-x86)
            else()
                set (FMOD_PLATFORM linux-x86_64)
            endif()

        elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "(ARM)|(arm)")
            if (CMAKE_SIZEOF_VOID_P EQUAL 4)
                set (FMOD_PLATFORM linux-arm)
            else()
                set (FMOD_PLATFORM linux-arm64)
            endif()
        else()
            message(FATAL_ERROR
                "Linux with architecture ${CMAKE_SYSTEM_PROCESSOR} is not supported")
        endif()

    elseif(ANDROID)

        message(FATAL_ERROR "Android platform detection not implemented yet")

    elseif(EMSCRIPTEN)

        set (FMOD_PLATFORM html5-w32)
        set(FMOD_LIB_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/${FMOD_VERSION}/lib/${FMOD_PLATFORM})
        set(FMOD_LIBS
            ${FMOD_LIB_ROOT}/fmod${FMOD_LIB_TYPE}_wasm.a
        )
        set(FMOD_STUDIO_LIBS
            ${FMOD_LIB_ROOT}/fmodstudio${FMOD_LIB_TYPE}_wasm.a
        )

    endif()

    message(STATUS "FMOD cmake platform folder detected: \"${FMOD_VERSION}/${FMOD_PLATFORM}\"")
endif()

set(FMOD_INCLUDE_DIR ${FMOD_VERSION}/include)

add_library(fmod INTERFACE)
target_link_libraries(fmod INTERFACE ${FMOD_LIBS})
target_include_directories(fmod INTERFACE ${FMOD_INCLUDE_DIR})

add_library(fmodstudio INTERFACE)
target_link_libraries(fmodstudio INTERFACE ${FMOD_STUDIO_LIBS})
target_include_directories(fmodstudio INTERFACE ${FMOD_INCLUDE_DIR})

if (EMSCRIPTEN)
    target_link_options(fmod INTERFACE
        -sEXPORTED_RUNTIME_METHODS=['cwrap','setValue','getValue'])
    target_link_options(fmodstudio INTERFACE
        -sEXPORTED_RUNTIME_METHODS=['cwrap','setValue','getValue'])
else()
    # add fmod dependency on non-emscripten platforms since it emscripten includes it automatically
    target_link_libraries(fmodstudio INTERFACE fmod)
endif()
