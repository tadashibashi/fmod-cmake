# Sets the PLATFORM_VAR variable, which is the subdirectory of lib where the FMOD libs are located
# for the detected platform.
macro(fmod_detect_platform PLATFORM_VAR)
    # FIXME: this regex can be simplified a lot, it's 'just adapted from a StackOverflow post that "works"
    set(X86_64_REGEX "(x86)|(X86)|(amd64)|(AMD64)|(x86_64)|(X86_64)|(x86-64)|(X86-64)|(x64)|(X64)")

	if (IOS)
		message(FATAL_ERROR "fmod-cmake error: ios platform not supported yet")
	elseif(APPLE)
		set(${PLATFORM_VAR} "macos")
	elseif(WIN32)
		if (NOT MSVC) # FMOD only provides MSVC builds across all archs
            message(FATAL_ERROR "Non-MSVC Windows compilers not supported")
        endif()

        if (CMAKE_SYSTEM_PROCESSOR MATCHES ${X86_64_REGEX})
            if (CMAKE_SIZEOF_VOID_P EQUAL 4)
                set (${PLATFORM_VAR} windows-x86)
            else()
                set (${PLATFORM_VAR} windows-amd64)
            endif()
        elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "(arm)|(ARM)" AND CMAKE_SIZEOF_VOID_P EQUAL 8)
            set (${PLATFORM_VAR} windows-arm64)
        else()
            message(FATAL_ERROR "Windows with architecture ${CMAKE_SYSTEM_PROCESSOR} is not supported")
        endif()
    elseif(LINUX)
        message(WARNING "Linux is not tested and supported yet")

        if (CMAKE_SYSTEM_PROCESSOR MATCHES ${X86_64_REGEX})
            if (CMAKE_SIZEOF_VOID_P EQUAL 4)
                set (${PLATFORM_VAR} linux-x86)
            else()
                set (${PLATFORM_VAR} linux-x86_64)
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
        message(FATAL_ERROR "fmod-cmake: Android not supported yet")
    elseif(EMSCRIPTEN)
        set (FMOD_PLATFORM html5-w32)
    endif()
endmacro()

# Find the FMOD libraries by platform and version
# @param _PLATFORM_NAME    [in] name of the platform folder
# @param _VERSION          [in] name of the version folder
# @param _FMOD_LIBS        [out] name of the variable to output FMOD Core libraries to
# @param _FMOD_STUDIO_LIBS [out] name of the variable to output FMOD Studio libraries to
# @param _FMOD_DLLS        [out] name of the variable to output FMOD DLLS to (on non-Windows platform, the var will always be set to "")
macro(fmod_find_libs _PLATFORM_NAME _VERSION _FMOD_LIBS _FMOD_STUDIO_LIBS _FMOD_DLLS)
    # Determine that library root directory
    set(FMOD_LIB_ROOT ${FMOD_CMAKE_ROOT}/fmod/${_VERSION}/lib/${_PLATFORM_NAME})

    set(${_FMOD_DLLS} "")

    # On debug builds, link to the FMOD logging libraries
    string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE_UPPER)
    if (BUILD_TYPE_UPPER MATCHES "DEBUG" OR BUILD_TYPE_UPPER MATCHES "RELWITHDEBINFO")
        set(FMOD_LIB_TYPE "L")
    else()
        set(FMOD_LIB_TYPE "")
    endif()
    
    # Get the library files per platform
    if (IOS)
        # TODO: implement this
        message(FATAL_ERROR "fmod-cmake ios platform not implemented yet")
    elseif(APPLE)
        set(${_FMOD_LIBS}        ${FMOD_LIB_ROOT}/libfmod${FMOD_LIB_TYPE}.dylib)
        set(${_FMOD_STUDIO_LIBS} ${FMOD_LIB_ROOT}/libfmodstudio${FMOD_LIB_TYPE}.dylib)
    elseif(WIN32)
        set(${_FMOD_LIBS}        ${FMOD_LIB_ROOT}/fmod${FMOD_LIB_TYPE}_vc.lib)
        set(${_FMOD_STUDIO_LIBS} ${FMOD_LIB_ROOT}/fmodstudio${FMOD_LIB_TYPE}_vc.lib)
        set(${_FMOD_DLLS} 
            ${FMOD_LIB_ROOT}/fmod${FMOD_LIB_TYPE}.dll
            ${FMOD_LIB_ROOT}/fmodstudio${FMOD_LIB_TYPE}.dll
        )
    elseif(LINUX)
        # TODO: implement this
        message(FATAL_ERROR "fmod-cmake: Linux platform is not tested and supported yet")
    elseif(ANDROID)
        message(FATAL_ERROR "fmod-cmake: Android platform detection not implemented yet")
    elseif(EMSCRIPTEN)
        set(${_FMOD_LIBS}        ${FMOD_LIB_ROOT}/fmod${FMOD_LIB_TYPE}_wasm.a)
        set(${_FMOD_STUDIO_LIBS} ${FMOD_LIB_ROOT}/fmodstudio${FMOD_LIB_TYPE}_wasm.a)
    endif()
endmacro()
