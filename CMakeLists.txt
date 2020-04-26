cmake_minimum_required(VERSION 3.5.0)

# scikit-build test
if(SKBUILD)
    message(STATUS "The project is built using scikit-build")
endif()
message(STATUS "The generator is: ${CMAKE_GENERATOR}")
message(STATUS "The build type is: ${CMAKE_BUILD_TYPE}")
message(STATUS "The toolchain is: ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "xxx BUILD_SHARED_LIBS: ${BUILD_SHARED_LIBS}")
message(STATUS "xxx CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "xxx CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "xxx CMAKE_INSTALL_INCLUDEDIR: ${CMAKE_INSTALL_INCLUDEDIR}")
message(STATUS "xxx CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "xxx CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")


# set the project name
project(videoplayer)


if (POLICY CMP0072)
    cmake_policy(SET CMP0072 OLD)
endif(POLICY CMP0072)

# manage dependencies
## set vars
set(_WIN_DEP OFF CACHE BOOL "Use dependencies from an external package")
set(_CONAN OFF CACHE BOOL "Use dependencies installed via conan (not dependency package)")
set(_VCPKG OFF CACHE BOOL "Use dependencies installed via vcpkg (not dependency package)")
set(VCPKG_APPLOCAL_DEPS ${_VCPKG} BOOL)

## find python deps
find_package(PythonExtensions REQUIRED)
find_package(Cython REQUIRED)

## get deps
if (WIN32 AND _WIN_DEP)
    message(STATUS "Use downloaded dependencies")
    set(DEPENDENCY_FOLDER "${PROJECT_SOURCE_DIR}/win_dep")
    find_path(GLIB2_INCLUDE_DIRS NAMES glib.h PATHS "${DEPENDENCY_FOLDER}/include/glib-2.0")
    find_library(GLIB2_LIBRARIES NAMES glib-2.0 PATHS "${DEPENDENCY_FOLDER}/lib")
    find_library(OGG_LIBRARIES NAMES ogg libogg PATHS "${DEPENDENCY_FOLDER}/lib")
    find_library(THEORADEC_LIBRARIES NAMES theoradec libtheoradec theora-dec PATHS "${DEPENDENCY_FOLDER}/lib")
    find_library(LIBSWSCALE_LIBRARIES NAMES swscale libswscale PATHS "${DEPENDENCY_FOLDER}/lib")
    find_package(OpenGL)

elseif(_CONAN)
    # conan.io
    message(STATUS "Use Conan")
    # download the the conan.cmake file
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
       message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
       file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake"
                     "${CMAKE_BINARY_DIR}/conan.cmake")
    endif()
    include(${CMAKE_BINARY_DIR}/conan.cmake)

    # check if conan is intalled
    conan_check(VERSION 1.24.0 REQUIRED)

    # add the bincrafters remote
    conan_add_remote(NAME bincrafters INDEX 1
                     URL https://api.bintray.com/conan/bincrafters/public-conan)

    # run conan install
    conan_cmake_run(CONANFILE conanfile.txt
                    BASIC_SETUP CMAKE_TARGETS
                    BUILD missing)

    # setup conan vars
    #include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    #conan_basic_setup(TARGETS)

    # find dependencies
    include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
    find_package(glib)
    set(GLIB2_FOUND ${glib_FOUND})
    set(GLIB2_INCLUDE_DIRS ${glib_INCLUDE_DIRS})
    set(GLIB2_LIBRARIES ${glib_LIBRARIES})
    find_package(ogg)
    set(OGG_FOUND ${ogg_FOUND})
    set(OGG_INCLUDE_DIRS ${ogg_INCLUDE_DIRS})
    set(OGG_LIBRARIES ${ogg_LIBRARIES})
    find_package(theora)
    set(THEORADEC_FOUND ${theora_FOUND})
    set(THEORADEC_INCLUDE_DIRS ${theora_INCLUDE_DIRS})
    set(THEORADEC_LIBRARIES ${theora_LIBRARIES})
    find_package(ffmpeg)
    set(LIBSWSCALE_FOUND ${ffmpeg_FOUND})
    set(LIBSWSCALE_INCLUDE_DIRS ${ffmpeg_INCLUDE_DIRS})
    set(LIBSWSCALE_LIBRARIES ${ffmpeg_LIBRARIES})
    find_path(LIBSWSCALE_INCLUDE_DIRS "swscale.h" ${ffmpeg_INCLUDE_DIRS})
    find_package(OpenGL)

elseif(_VCPKG)
    message(STATUS "Use vcpkg")

    # set vcpkg vars
    set(VCPKG_CRT_LINKAGE dynamic)
    set(VCPKG_LIBRARY_LINKAGE dynamic)
    #set(VCPKG_DLL_FILES "C:\\tools\\vcpkg\\installed\\x64-windows\\bin")

    # find deps
    find_package(unofficial-glib CONFIG REQUIRED)  # unofficial::glib::glib
    find_path(GLIB2_INCLUDE_DIRS NAMES glib.h)
    find_library(GLIB2_LIBRARIES glib-2.0)
    set(GLIB2_FOUND ${unofficial-glib_FOUND})

    find_package(Ogg CONFIG REQUIRED)  # Ogg::ogg

    find_path(THEORADEC_INCLUDE_DIRS NAMES theora/theoradec.h)
    find_library(THEORADEC_LIBRARIES NAMES theoradec libtheoradec theora-dec)

    find_package(FFMPEG)
    set(LIBSWSCALE_FOUND ${FFMPEG_libswscale_FOUND})
    set(LIBSWSCALE_INCLUDE_DIRS ${FFMPEG_libswscale_INCLUDE_DIRS})
    set(LIBSWSCALE_LIBRARIES ${FFMPEG_libswscale_LIBRARY})

    find_package(OpenGL)

else()
    message(STATUS "Use pkgconfig")

    # pkgconfig
    find_package(PkgConfig REQUIRED)
    pkg_search_module(GLIB2 REQUIRED glib-2.0>=2.28 IMPORTED_TARGET)
    #pkg_search_module(OPENGL REQUIRED gl IMPORTED_TARGET)
    pkg_search_module(OGG ogg>=1.3.0 IMPORTED_TARGET)  # OGG::OGG
    pkg_search_module(THEORADEC theoradec>=1.1.0 IMPORTED_TARGET)  # THEORA::DEC
    pkg_search_module(LIBSWSCALE libswscale>=1.1.3 IMPORTED_TARGET)  # FFMPEG::swscale
    find_package(OpenGL)
endif()

add_subdirectory(videoplayer)
