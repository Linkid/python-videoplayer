# Steps:
# - compile the external lib
# - cythonize the pyx file (to get a C file)
# - compile the extension
# - install the module


# debug
# -------------- #
message(STATUS "zzzz GLIB2_LIBRARIES: ${GLIB2_LIBRARIES}")
message(STATUS "zzzz GLIB2_LIB_DIRS: ${GLIB2_LIB_DIRS}")
message(STATUS "zzzz GLIB2_LDFLAGS: ${GLIB2_LDFLAGS}")
message(STATUS "zzzz GLIB2_VERSION: ${GLIB2_VERSION}")
message(STATUS "zzzz GLIB2_LIBDIR: ${GLIB2_LIBDIR}")
message(STATUS "zzzz GLIB2_LINK_LIBRARIES: ${GLIB2_LINK_LIBRARIES}")
message(STATUS "zzzz GLIB2_INCLUDE_DIRS: ${GLIB2_INCLUDE_DIRS}")
message(STATUS "zzzz GLIB2_LIBRARY_DIRS: ${GLIB2_LIBRARY_DIRS}")

message(STATUS "zzzz OGG_LIBRARIES: ${OGG_LIBRARIES}")
message(STATUS "zzzz OGG_LIB_DIRS: ${OGG_LIB_DIRS}")
message(STATUS "zzzz OGG_LDFLAGS: ${OGG_LDFLAGS}")
message(STATUS "zzzz OGG_VERSION: ${OGG_VERSION}")
message(STATUS "zzzz OGG_LIBDIR: ${OGG_LIBDIR}")
message(STATUS "zzzz OGG_LINK_LIBRARIES: ${OGG_LINK_LIBRARIES}")
message(STATUS "zzzz OGG_INCLUDE_DIRS: ${OGG_INCLUDE_DIRS}")
message(STATUS "zzzz OGG_LIBRARY_DIRS: ${OGG_LIBRARY_DIRS}")

#message(STATUS "zzzz LIBSWSCALE_LIBRARIES: ${LIBSWSCALE_LIBRARIES}")
#message(STATUS "zzzz LIBSWSCALE_INCLUDE_DIRS: ${LIBSWSCALE_INCLUDE_DIRS}")
message(STATUS "zzzz LIBSWSCALE_LIBRARIES: ${LIBSWSCALE_LIBRARIES}")
message(STATUS "zzzz LIBSWSCALE_LIB_DIRS: ${LIBSWSCALE_LIB_DIRS}")
message(STATUS "zzzz LIBSWSCALE_LDFLAGS: ${LIBSWSCALE_LDFLAGS}")
message(STATUS "zzzz LIBSWSCALE_VERSION: ${LIBSWSCALE_VERSION}")
message(STATUS "zzzz LIBSWSCALE_LIBDIR: ${LIBSWSCALE_LIBDIR}")
message(STATUS "zzzz LIBSWSCALE_LINK_LIBRARIES: ${LIBSWSCALE_LINK_LIBRARIES}")
message(STATUS "zzzz LIBSWSCALE_INCLUDE_DIRS: ${LIBSWSCALE_INCLUDE_DIRS}")
message(STATUS "zzzz LIBSWSCALE_LIBRARY_DIRS: ${LIBSWSCALE_LIBRARY_DIRS}")
# -------------- #


# cythonize the pyx file
add_cython_target(_VideoPlayer _VideoPlayer.pyx)

# compile the extension with the lib
add_library(_VideoPlayer MODULE ${_VideoPlayer} VideoPlayer.c)
target_include_directories(_VideoPlayer
    INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}
    PUBLIC ${GLIB2_INCLUDE_DIRS}
    PUBLIC ${LIBSWSCALE_INCLUDE_DIRS}  # for osx
)
target_link_libraries(_VideoPlayer
    ${GLIB2_LINK_LIBRARIES}  # for osx
    #${GLIB2_LIBRARIES}
    ${OGG_LINK_LIBRARIES}  # for osx
    #${OGG_LIBRARIES}
    ${THEORADEC_LINK_LIBRARIES}
    #${THEORADEC_LIBRARIES}
    ${OPENGL_LIBRARIES}
    ${LIBSWSCALE_LIBRARIES}
)
python_extension_module(_VideoPlayer)

# install the module
# skbuild: add_python_extension
install(TARGETS _VideoPlayer
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/videoplayer
    PRIVATE_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

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
endif()
