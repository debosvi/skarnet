cmake_minimum_required (VERSION 2.8)
project (skalibs)

#set (CMAKE_VERBOSE_MAKEFILE ON)

set(DEFAULT_INSTALL_DIR ${CMAKE_BINARY_DIR}/.built)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${DEFAULT_INSTALL_DIR}/lib)
#     set(LINK_FLAGS -Xlinker -rpath-link -Xlinker ${DEFAULT_INSTALL_DIR}/lib )
set (EXECUTABLE_OUTPUT_PATH ${DEFAULT_INSTALL_DIR}/bin)
set(CONTRIBS_INSTALL_DIR /usr/share)

include(project_ver.cmake)
include(ExternalProject)

# download dirname
set(3RD_DL_DIR ${CMAKE_BINARY_DIR}/.support)

# skalibs dirnames
set(SKA_PKG_DIR ${CMAKE_CURRENT_BINARY_DIR}/package)
set(SKARNET_STAGING_DIR ${CMAKE_CURRENT_BINARY_DIR}/../skarnet)
set(SKARNET_SYSDEPS_DIR ${SKARNET_STAGING_DIR}/sysdeps)

set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download configure build install test)

set(SKALIBS_PACKAGE skalibs-${VERSION_STRING})
set(SKALIBS_CONF_COMPILE ${SKA_PKG_DIR}/prog/${SKALIBS_PACKAGE}/conf-compile)
set(SKALIBS_OUTPUT_DIR ${SKARNET_STAGING_DIR}/skalibs)

ExternalProject_Add(${PROJECT_NAME}
#    DEPENDS             
    STAMP_DIR           ${CMAKE_BINARY_DIR}/.stamps
    DOWNLOAD_DIR        ${3RD_DL_DIR}
    URL                 http://www.skarnet.org/software/skalibs/${SKALIBS_PACKAGE}.tar.gz
    URL_MD5             e2bfa4447977024e1f2f91e9eb880baa
    SOURCE_DIR          "${SKA_PKG_DIR}/prog"
    BUILD_IN_SOURCE     0
    CONFIGURE_COMMAND  
        echo "${SKA_PKG_DIR}"                           > ${SKALIBS_CONF_COMPILE}/conf-sp_root &&
        echo "${SKALIBS_OUTPUT_DIR}/bin"                > ${SKALIBS_CONF_COMPILE}/conf-install-command && 
        echo "${SKALIBS_OUTPUT_DIR}/library/skarnet"    > ${SKALIBS_CONF_COMPILE}/conf-install-library &&
        echo "${SKALIBS_OUTPUT_DIR}/library.so/skarnet" > ${SKALIBS_CONF_COMPILE}/conf-install-library.so &&
        echo "${SKALIBS_OUTPUT_DIR}/include/skarnet"    > ${SKALIBS_CONF_COMPILE}/conf-install-include &&
        echo "${SKALIBS_OUTPUT_DIR}/etc"                > ${SKALIBS_CONF_COMPILE}/conf-etc &&
        echo "${SKARNET_SYSDEPS_DIR}"                   > ${SKALIBS_CONF_COMPILE}/conf-install-sysdeps &&
        rm -f ${SKALIBS_CONF_COMPILE}/flag-slashpackage
    BUILD_COMMAND
        mkdir -p ${SKALIBS_OUTPUT_DIR}/etc &&
        make -C ${SKA_PKG_DIR}/prog/${SKALIBS_PACKAGE} 
    INSTALL_COMMAND make -C ${SKA_PKG_DIR}/prog/${SKALIBS_PACKAGE} install
    )

install(DIRECTORY ${SKALIBS_OUTPUT_DIR}/include/skarnet 
    DESTINATION ${CONTRIBS_INSTALL_DIR}/include/
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.h"
    )

install(DIRECTORY ${SKALIBS_OUTPUT_DIR}/library.so/skarnet 
    DESTINATION ${CONTRIBS_INSTALL_DIR}/lib
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.so*"
    )

install(DIRECTORY ${SKALIBS_OUTPUT_DIR}/etc
    DESTINATION /
    USE_SOURCE_PERMISSIONS
    )

configure_file(SkarnetConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/SkarnetConfig.cmake @ONLY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/SkarnetConfig.cmake DESTINATION ${CONTRIBS_INSTALL_DIR}/lib/cmake )

include(package.cmake)
