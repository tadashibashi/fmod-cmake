# FMOD CMake

Adds a CMake interface library for linking to FMOD Studio and Core APIs on multiple platforms for C/C++ projects.

Since the FMOD API is proprietary, its distribution is limited to downloads from
the FMOD website. To abide by the copyright, this project only defines a
folder structure into which you can copy/move these files and does not contain the actual files themselves.

Currently tested and working on
- MacOS arm64 / x86_64
- Emscripten WASM

### How to use

#### 1. Clone this project as a submodule in your repository

#### 2. Get FMOD

Determine which FMOD API platforms and version you need, and download each from fmod.com.

Then extract and install the files on your computer.

*Note:* you will need to make an account with FMOD to access the downloads page. If using FMOD commercially, please check your use case and licensing tier.

#### 3. Copy FMOD Headers

All FMOD Studio API downloads include the C/C++ header files.

Find the headers in one of the downloads, usually located at `api/core/inc` and `api/studio/inc` for both Core and Studio APIs, respectively.

Copy all `.h` and `.hpp` into this repository's `fmod/<version-number>/include` folder. For example, if your version of FMOD is 2.02.21, the headers should go into `fmod/2.02.21/include`. Any other file types like `.cs` are not necessary.

*Note:* using version number folders, you may support multiple FMOD versions and easily choose which to target by setting the `FMOD_VERSION` variable, as you will soon see in step 5.

#### 4. Copy FMOD library files for each platform

##### Mac OS (both x86_64 and arm64)

Library file locations (from download)
- Core:   `api/core/lib`
    - libfmod.dylib
    - libfmodL.dylib

- Studio: `api/studio/lib`
    - libfmodstudio.dylib
    - libfmodstudioL.dylib

In this repo, copy these files to:
    `fmod/<version>/lib/macos`

##### HTML5

Library file locations (from download)
- Core:   `api/core/lib/upstream/w32`
    - fmod_wasm.a
    - fmodL_wasm.a

- Studio: `api/studio/lib/upstream/w32`
    - fmodstudio_wasm.a
    - fmodstudioL_wasm.a

In this repo, copy these files to:
    `fmod/<version>/lib/html5-w32`

*Platform Note:*
The best way to set up Emscripten builds in CMake is by passing `-DCMAKE_TOOLCHAIN_FILE=<path/to/Emscripten.cmake>` during the CMake generation step. This flag's value should contain the actual path to the `Emscripten.cmake` toolchain file located in an Emscripten installation on your system. It's usually located in `<emsdk-root>/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake`

##### More platforms to come...

*Note:* You only need to provide what you want to support building for.

For example, if you only need to link FMOD Core, you don't need to copy any of the FMOD Studio headers or libraries; or if you only need to build for Windows x86_64, then there's no need to add Windows arm64 files, etc.

#### 5. Consume the FMOD CMake Interface

In your `CMakeLists.txt` file, add this repository submodule as a subdirectory, specifying `FMOD_VERSION`. The version you set should directly correlate with the subfolder name.

For example, for libraries inside of `fmod/2.02.21`, use:

```cmake
set(FMOD_VERSION 2.02.21 CACHE STRING "" FORCE)
add_subdirectory(lib/fmod-cmake)
```

Add link target `fmod` for FMOD Core, and `fmodstudio` for FMOD Studio
```cmake
add_executable(my_exe main.cpp)
target_link_libraries(my_exe PRIVATE fmod)
```

*Note:* You may bypass auto-platform-detection by explicitly setting the platform lib sub-folder via `set(FMOD_PLATFORM "macos" CACHE STRING "" FORCE)`

### Contributing

Please submit an issue for suggestions, requests or bug reports, and submit a pull request if you want to merge support for any of the following:

- Support for other platforms (Linux, Mobile, Consoles, etc.)
- Added robustness to CMake files fixing bugs and covering edge cases, etc.
- CMake compilation tests, library and header location checks, provide better error messages
