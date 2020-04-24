# include local headers
# XXX: deprecated
#include_directories(${CMAKE_CURRENT_SOURCE_DIR})
#include_directories(
#    ${GLIB2_INCLUDE_DIRS}
#)
## XXX: deprecated
#link_directories(
#    ${GLIB2_LIBRARY_DIRS}
#    ${OGG_LIBRARY_DIRS}
#    ${THEORADEC_LIBRARY_DIRS}
#    ${OPENGL_LIBRARY_DIRS}
#    ${LIBSWSCALE_LIBRARY_DIRS}
#)


##################
# VideoPlayer lib
##################

# compile the external lib
add_library(VideoPlayer VideoPlayer.c)
target_include_directories(VideoPlayer
    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC ${GLIB2_INCLUDE_DIRS}
    #PUBLIC ${LIBSWSCALE_INCLUDE_DIRS}
)
target_link_libraries(VideoPlayer
    PRIVATE ${GLIB2_LIBRARIES}
    PRIVATE ${OGG_LIBRARIES}
    PRIVATE ${THEORADEC_LIBRARIES}
    PRIVATE ${OPENGL_LIBRARIES}
    PRIVATE ${LIBSWSCALE_LIBRARIES}
)
install(TARGETS VideoPlayer
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    PRIVATE_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
message(STATUS "yyyyyy CMAKE_INSTALL_INCLUDEDIR: ${CMAKE_INSTALL_INCLUDEDIR}")
message(STATUS "yyyyyy CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}")

#####################
# VideoPlayer module
#####################

# cythonize the pyx file to get the .c file
add_cython_target(_VideoPlayer _VideoPlayer.pyx)
add_library(_VideoPlayer MODULE ${_VideoPlayer})

# compile the extension
target_link_libraries(_VideoPlayer
    VideoPlayer
)
python_extension_module(_VideoPlayer)

# install the module
install(TARGETS _VideoPlayer
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)
install(FILES ${videoplayer_BINARY_DIR}/videoplayer/_VideoPlayer.c DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)
message(STATUS "yyyyyy videoplayer_BINARY_DIR: ${videoplayer_BINARY_DIR}")
message(STATUS "yyyyyy CMAKE_CURRENT_BINARY_DIR: ${CMAKE_CURRENT_BINARY_DIR}")
message(STATUS "yyyyyy CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "yyyyyy CMAKE_INSTALL_CONFIG_NAME: ${CMAKE_INSTALL_CONFIG_NAME}")

# copy dlls
if (WIN32)
    file(GLOB DEPENDENCIES_DLL "${videoplayer_BINARY_DIR}/videoplayer/**.dll")
    message(STATUS "zzz cmake_current_binary_dir: ${CMAKE_CURRENT_BINARY_DIR}")
    message(STATUS "zzz list dll: ${DEPENDENCIES_DLL}")
    ## Copy dlls on windows
    #add_custom_command(TARGET _VideoPlayer POST_BUILD
    #    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    #    "${videoplayer_BINARY_DIR}/videoplayer/glib-2.dll"
    #    "${CMAKE_INSTALL_PREFIX}/videoplayer")
    #    #$<TARGET_FILE_DIR:_VideoPlayer>)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/avutil-56.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/glib-2.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libcharset.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libiconv.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libintl.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/ogg.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/pcre.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/swscale-5.dll)
    #list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/theoradec.dll)
    message(STATUS "zzz list dll 2: ${DEPENDENCIES_DLL}")
    #install(FILES ${DEPENDENCIES_DLL}
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/videoplayer/Release
            DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer
            FILES_MATCHING PATTERN "*.dll")
endif()
