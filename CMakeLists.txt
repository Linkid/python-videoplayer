cmake_minimum_required(VERSION 3.5.0)

# set the project name
project(videoplayer)

# scikit-build test
if(SKBUILD)
    message(STATUS "The project is built using scikit-build")
endif()

# add path to a FindSomePackage.cmake file
#list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

find_package(Cython REQUIRED)
find_package(PythonExtensions REQUIRED)


# manage dependencies
if(_CONAN)
    message(STATUS "xxx Use conan xxx")
    # conan.io
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

    if (POLICY CMP0072)
        cmake_policy(SET CMP0072 OLD)
    endif(POLICY CMP0072)
    find_package(OpenGL)

elseif(_VCPKG)
    message(STATUS "xxx Use vcpkg xxx")

    find_package(unofficial-glib CONFIG REQUIRED)
    #list(APPEND THIRD_PARTY_LIBS unofficial::glib::glib)
    set(GLIB2_FOUND ${unofficial-glib_FOUND})
    set(GLIB2_INCLUDE_DIRS ${unofficial-glib_INCLUDE_DIR})
    set(GLIB2_LIBRARIES ${unofficial-glib_LIBRARY})
    message(STATUS "yyy found glib: ${GLIB2_FOUND}")
    message(STATUS "yyy found glib: ${unofficial-glib_INCLUDE_DIRS}")
    message(STATUS "yyy found glib: ${unofficial-glib_INCLUDE_DIR}")
    message(STATUS "yyy found glib: ${unofficial-glib_LIBRARIES}")
    message(STATUS "yyy found glib: ${unofficial-glib_LIBRARY}")

    find_package(Ogg CONFIG REQUIRED)
    #list(APPEND THIRD_PARTY_LIBS Ogg::ogg)
    #find_path(OGG_INCLUDE_DIRS NAMES ogg/ogg.h)
    #find_library(OGG_LIBRARIES NAMES ogg libogg)
    message(STATUS "yyy found ogg: ${OGG_FOUND}")

    find_path(THEORADEC_INCLUDE_DIRS NAMES theora/theoradec.h)
    find_library(THEORADEC_LIBRARIES NAMES theoradec libtheoradec theora-dec)
    message(STATUS "yyy found theora: ${THEORADEC_INCLUDE_DIRS}")
    message(STATUS "yyy found theora: ${THEORADEC_LIBRARIES}")

    find_package(FFMPEG)
    # FFMPEG_libswscale_INCLUDE_DIRS
    set(LIBSWSCALE_FOUND ${ffmpeg_FOUND})
    set(LIBSWSCALE_INCLUDE_DIRS ${ffmpeg_INCLUDE_DIRS})
    set(LIBSWSCALE_LIBRARIES ${ffmpeg_LIBRARIES})
    message(STATUS "yyy found ffmpeg: ${FFMPEG_FOUND}")

    find_package(OpenGL)

else()
    message(STATUS "xxx Use pkgconfig xxx")

    # pkgconfig
    find_package(PkgConfig REQUIRED)
    pkg_search_module(GLIB2 REQUIRED glib-2.0>=2.34 IMPORTED_TARGET)
    pkg_search_module(OPENGL REQUIRED gl IMPORTED_TARGET)
    pkg_search_module(OGG REQUIRED ogg>=1.3.0 IMPORTED_TARGET)  # OGG::OGG
    pkg_search_module(THEORADEC REQUIRED theoradec>=1.1.0 IMPORTED_TARGET)  # THEORA::DEC
    pkg_search_module(LIBSWSCALE REQUIRED libswscale>=1.1.3 IMPORTED_TARGET)  # FFMPEG::swscale
endif()

add_subdirectory(videoplayer)
