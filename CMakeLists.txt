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
set(USE_WIN_DEP OFF CACHE BOOL "Use dependencies from an external package")

## find python deps
find_package(Python REQUIRED)
find_package(PythonExtensions REQUIRED)
find_package(Cython REQUIRED)

## get deps
if (WIN32 AND USE_WIN_DEP)
    message(STATUS "Use downloaded dependencies")

    set(DEPENDENCY_FOLDER "${PROJECT_SOURCE_DIR}/win_dep")

    # glib
    find_path(GLIB2_INCLUDE_DIRS_0 NAMES glib.h PATHS "${DEPENDENCY_FOLDER}/include/glib-2.0")
    find_path(GLIB2_INCLUDE_DIRS_1 NAMES glibconfig.h PATHS "${DEPENDENCY_FOLDER}/lib/glib-2.0/include")
    list(APPEND GLIB2_INCLUDE_DIRS ${GLIB2_INCLUDE_DIRS_0})
    list(APPEND GLIB2_INCLUDE_DIRS ${GLIB2_INCLUDE_DIRS_1})
    find_library(GLIB2_LINK_LIBRARIES NAMES glib-2.0 PATHS "${DEPENDENCY_FOLDER}/lib")
    # ogg
    find_path(OGG_INCLUDE_DIRS NAMES ogg/ogg.h PATHS "${DEPENDENCY_FOLDER}/include/")
    find_library(OGG_LINK_LIBRARIES NAMES ogg libogg PATHS "${DEPENDENCY_FOLDER}/lib")
    # theora
    find_path(THEORADEC_INCLUDE_DIRS NAMES theora/theoradec.h PATHS "${DEPENDENCY_FOLDER}/include")
    find_library(THEORADEC_LINK_LIBRARIES NAMES theoradec libtheoradec theora-dec PATHS "${DEPENDENCY_FOLDER}/lib")
    # libswscale
    find_path(LIBSWSCALE_INCLUDE_DIRS NAMES libswscale/swscale.h PATHS "${DEPENDENCY_FOLDER}/include")
    find_library(LIBSWSCALE_LIBRARIES NAMES swscale libswscale PATHS "${DEPENDENCY_FOLDER}/lib")
    # opengl
    find_package(OpenGL)
    # msinttypes
    find_path(MSINTTYPES_INCLUDE_DIRS_0 NAMES stdint.h PATHS "${DEPENDENCY_FOLDER}/include/msinttypes")
    find_path(MSINTTYPES_INCLUDE_DIRS_1 NAMES inttypes.h PATHS "${DEPENDENCY_FOLDER}/include/msinttypes")
    list(APPEND MSINTTYPES_INCLUDE_DIRS ${MSINTTYPES_INCLUDE_DIRS_0})
    list(APPEND MSINTTYPES_INCLUDE_DIRS ${MSINTTYPES_INCLUDE_DIRS_1})

else()
    message(STATUS "Use pkgconfig")

    find_package(PkgConfig REQUIRED)
    pkg_search_module(GLIB2 REQUIRED glib-2.0>=2.12 IMPORTED_TARGET)
    pkg_search_module(OGG ogg>=1.1.0 IMPORTED_TARGET)  # OGG::OGG
    pkg_search_module(THEORADEC theoradec IMPORTED_TARGET)  # THEORA::DEC

    if(APPLE)
        find_path(LIBSWSCALE_INCLUDE_DIRS
            NAMES libswscale/swscale.h
            PATH_SUFFIXES include include/ffmpeg
        )
        find_library(LIBSWSCALE_LIBRARIES
            NAMES swscale
            PATH_SUFFIXES bin lib
        )
    else()
        pkg_search_module(LIBSWSCALE libswscale>=1.1.3)  # FFMPEG::swscale
    endif()

    find_package(OpenGL)
    #pkg_search_module(OPENGL REQUIRED gl IMPORTED_TARGET)
endif()


# build the project
add_subdirectory(videoplayer)
