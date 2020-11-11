cmake_minimum_required(VERSION 3.5.0)

# scikit-build test
if(SKBUILD)
    message(STATUS "The project is built using scikit-build")
endif()

message(STATUS "The generator is: ${CMAKE_GENERATOR}")
message(STATUS "The build type is: ${CMAKE_BUILD_TYPE}")
message(STATUS "The toolchain is: ${CMAKE_TOOLCHAIN_FILE}")


# set the project name
project(videoplayer)


if (POLICY CMP0072)
    cmake_policy(SET CMP0072 OLD)
endif(POLICY CMP0072)

# manage dependencies
## set vars
set(_WIN_DEP OFF CACHE BOOL "Use dependencies from an external package")
set(_VCPKG OFF CACHE BOOL "Use dependencies installed via vcpkg (not dependency package)")

## find python deps
find_package(Python REQUIRED)
find_package(PythonExtensions REQUIRED)
find_package(Cython REQUIRED)

## get deps
if (WIN32 AND _WIN_DEP)
    message(STATUS "[-] Use downloaded dependencies")

    set(DEPENDENCY_FOLDER "${PROJECT_SOURCE_DIR}/win_dep")
    find_path(GLIB2_INCLUDE_DIRS NAMES glib.h PATHS "${DEPENDENCY_FOLDER}/include/glib-2.0")
    find_library(GLIB2_LIBRARIES NAMES glib-2.0 PATHS "${DEPENDENCY_FOLDER}/lib")
    find_library(OGG_LIBRARIES NAMES ogg libogg PATHS "${DEPENDENCY_FOLDER}/lib")
    find_library(THEORADEC_LIBRARIES NAMES theoradec libtheoradec theora-dec PATHS "${DEPENDENCY_FOLDER}/lib")
    find_library(LIBSWSCALE_LIBRARIES NAMES swscale libswscale PATHS "${DEPENDENCY_FOLDER}/lib")
    find_package(OpenGL)

elseif(_VCPKG)
    message(STATUS "[-] Use vcpkg")

    # set vcpkg vars
    set(VCPKG_CRT_LINKAGE dynamic)
    set(VCPKG_LIBRARY_LINKAGE dynamic)

    # find deps
    ## glib
    find_path(GLIB2_INCLUDE_DIRS NAMES glib.h)
    find_library(GLIB2_LINK_LIBRARIES glib-2.0)
    ## ogg
    find_path(OGG_INCLUDE_DIRS NAMES ogg/ogg.h)
    find_library(OGG_LINK_LIBRARIES ogg libogg)
    ## theora
    find_path(THEORADEC_INCLUDE_DIRS NAMES theora/theoradec.h)
    find_library(THEORADEC_LINK_LIBRARIES NAMES theoradec libtheoradec theora-dec)
    ## libswscale
    find_package(FFMPEG)
    set(LIBSWSCALE_FOUND ${FFMPEG_libswscale_FOUND})
    set(LIBSWSCALE_INCLUDE_DIRS ${FFMPEG_libswscale_INCLUDE_DIRS})
    set(LIBSWSCALE_LIBRARIES ${FFMPEG_libswscale_LIBRARY})
    ## opengl
    find_package(OpenGL)

else()
    message(STATUS "[-] Use pkgconfig")

    find_package(PkgConfig REQUIRED)
    pkg_search_module(GLIB2 REQUIRED glib-2.0>=2.28 IMPORTED_TARGET)
    pkg_search_module(OGG ogg>=1.3.0 IMPORTED_TARGET)  # OGG::OGG
    pkg_search_module(THEORADEC theoradec>=1.1.0 IMPORTED_TARGET)  # THEORA::DEC
    #pkg_search_module(LIBSWSCALE libswscale>=1.1.3)  # FFMPEG::swscale
    find_path(LIBSWSCALE_INCLUDE_DIRS
        NAMES libswscale/swscale.h
        PATH_SUFFIXES include include/ffmpeg
    )
    find_library(LIBSWSCALE_LIBRARIES
        NAMES swscale
        PATH_SUFFIXES bin lib
    )
    find_package(OpenGL)
    #pkg_search_module(OPENGL REQUIRED gl IMPORTED_TARGET)
endif()


# build the project
add_subdirectory(videoplayer)
