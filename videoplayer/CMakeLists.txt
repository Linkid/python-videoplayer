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
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

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
install(TARGETS _VideoPlayer LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)
install(FILES ${videoplayer_BINARY_DIR}/videoplayer/_VideoPlayer.c DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)

# copy dlls
if (WIN32)
    message(STATUS "zzz cmake_current_binary_dir: ${CMAKE_CURRENT_BINARY_DIR}")
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libglib-2.0-0.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libogg-0.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/libtheoradec-1.dll)
    list(APPEND DEPENDENCIES_DLL ${CMAKE_CURRENT_BINARY_DIR}/swscale-2.dll)
    install(FILES ${DEPENDENCIES_DLL} DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer)  #FILES_MATCHING PATTERN "*.dll"
endif()
