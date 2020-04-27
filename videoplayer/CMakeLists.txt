# include local headers (deprecated)
#include_directories(${CMAKE_CURRENT_SOURCE_DIR})


#execute_process(
#    COMMAND ls -l /usr/include/libswscale/
#)
#execute_process(
#    COMMAND ls -l /usr/include/ffmpeg/libswscale/
#)
message(STATUS "zzzz LIBSWSCALE_LIBRARIES: ${LIBSWSCALE_LIBRARIES}")
message(STATUS "zzzz LIBSWSCALE_INCLUDE_DIRS: ${LIBSWSCALE_INCLUDE_DIRS}")

add_cython_target(_VideoPlayer _VideoPlayer.pyx)
add_library(_VideoPlayer MODULE ${_VideoPlayer} VideoPlayer.c)

target_include_directories(_VideoPlayer
    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC ${GLIB2_INCLUDE_DIRS}
    PUBLIC ${LIBSWSCALE_INCLUDE_DIRS}
)
target_link_libraries(_VideoPlayer
    ${GLIB2_LIBRARIES}
    ${OGG_LIBRARIES}
    ${THEORADEC_LIBRARIES}
    ${OPENGL_LIBRARIES}
    ${LIBSWSCALE_LIBRARIES}
)
python_extension_module(_VideoPlayer)
install(TARGETS _VideoPlayer
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer
    PRIVATE_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)


###################
## VideoPlayer lib
###################
#
## compile the external lib
#add_library(VideoPlayer OBJECT VideoPlayer.c)
#target_include_directories(VideoPlayer
#    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
#    PUBLIC ${GLIB2_INCLUDE_DIRS}
#)
#target_link_libraries(VideoPlayer
#    PRIVATE ${GLIB2_LIBRARIES}
#    PRIVATE ${OGG_LIBRARIES}
#    PRIVATE ${THEORADEC_LIBRARIES}
#    PRIVATE ${OPENGL_LIBRARIES}
#    PRIVATE ${LIBSWSCALE_LIBRARIES}
#)
#install(TARGETS VideoPlayer
#    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
#    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
#)
#
#
######################
## VideoPlayer module
######################
#
## cythonize the pyx file to get the .c file
#add_cython_target(_VideoPlayer _VideoPlayer.pyx)
#add_library(_VideoPlayer MODULE ${_VideoPlayer})
#
## compile the extension
#target_link_libraries(_VideoPlayer
#    VideoPlayer
#)
#python_extension_module(_VideoPlayer)
#
## install the module
#install(TARGETS _VideoPlayer
#    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer
#)
install(FILES ${videoplayer_BINARY_DIR}/videoplayer/_VideoPlayer.c DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)

# Copy dlls on windows
if (WIN32)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/avutil-56.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/glib-2.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libcharset.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libiconv.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libintl.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/ogg.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/pcre.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/swscale-5.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/theoradec.dll)
    install(FILES ${DEPENDENCIES_DLL}
            DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)

    #file(GLOB DEPENDENCIES_DLL "${videoplayer_BINARY_DIR}/videoplayer/**.dll")
    #add_custom_command(TARGET _VideoPlayer POST_BUILD
    #    COMMAND ${CMAKE_COMMAND} -E copy_if_different
    #    "${videoplayer_BINARY_DIR}/videoplayer/glib-2.dll"
    #    "${CMAKE_INSTALL_PREFIX}/videoplayer")
    #    #$<TARGET_FILE_DIR:_VideoPlayer>)
    #install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/videoplayer/Release
    #        DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)
    #        FILES_MATCHING PATTERN "*.dll")
endif()
