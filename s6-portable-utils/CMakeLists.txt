cmake_minimum_required (VERSION 2.8)
project (s6-portable-utils)

set(DEFAULT_INSTALL_DIR ${CMAKE_BINARY_DIR}/.built)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${DEFAULT_INSTALL_DIR}/lib)
#     set(LINK_FLAGS -Xlinker -rpath-link -Xlinker ${DEFAULT_INSTALL_DIR}/lib )
set (EXECUTABLE_OUTPUT_PATH ${DEFAULT_INSTALL_DIR}/bin)
set(CONTRIBS_INSTALL_DIR /usr/share)

include(project_ver.cmake)
include(ExternalProject)

# download dirname
set(3RD_DL_DIR ${CMAKE_BINARY_DIR}/../.support)

# s6-portable-utils dirnames
set(SKA_PKG_DIR ${CMAKE_CURRENT_BINARY_DIR}/package)
set(SKARNET_STAGING_DIR ${CMAKE_CURRENT_BINARY_DIR}/../skarnet)
set(SKARNET_SYSDEPS_DIR ${SKARNET_STAGING_DIR}/sysdeps)

set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download configure build install test)

set(S6PORTABLE_UTILS_PACKAGE s6-portable-utils-${VERSION_STRING})
set(S6PORTABLE_UTILS_CONF_COMPILE ${SKA_PKG_DIR}/prog/${S6PORTABLE_UTILS_PACKAGE}/conf-compile)
set(S6PORTABLE_UTILS_OUTPUT_DIR ${SKARNET_STAGING_DIR}/s6-portable-utils)

ExternalProject_Add(${PROJECT_NAME}
#    DEPENDS             
    STAMP_DIR           ${CMAKE_BINARY_DIR}/.stamps
    DOWNLOAD_DIR        ${3RD_DL_DIR}
    URL                 http://www.skarnet.org/software/s6-portable-utils/s6-portable-utils-${VERSION_STRING}.tar.gz
    URL_MD5             f5ce5e9a37a321d12c7e16e91b1a7eeb
    SOURCE_DIR          "${SKA_PKG_DIR}/prog"
    BUILD_IN_SOURCE     0
    CONFIGURE_COMMAND  
        echo "${SKARNET_SYSDEPS_DIR}"                               > ${S6PORTABLE_UTILS_CONF_COMPILE}/import && 
        echo "${SKARNET_STAGING_DIR}/skalibs/include/skarnet"       > ${S6PORTABLE_UTILS_CONF_COMPILE}/path-include && 
        echo "${SKARNET_STAGING_DIR}/skalibs/library/skarnet"       > ${S6PORTABLE_UTILS_CONF_COMPILE}/path-library && 
        echo "${SKARNET_STAGING_DIR}/skalibs/library.so/skarnet"    > ${S6PORTABLE_UTILS_CONF_COMPILE}/path-library.so && 
        echo "${SKA_PKG_DIR}"                                       > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-sp_root &&
        echo "${S6PORTABLE_UTILS_OUTPUT_DIR}/command"               > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-install-command && 
        echo "${S6PORTABLE_UTILS_OUTPUT_DIR}/library/skarnet"       > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-install-library &&
        echo "${S6PORTABLE_UTILS_OUTPUT_DIR}/library.so/skarnet"    > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-install-library.so &&
        echo "${S6PORTABLE_UTILS_OUTPUT_DIR}/include/skarnet"       > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-install-include &&
        echo "${S6PORTABLE_UTILS_OUTPUT_DIR}/etc"                   > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-etc &&
        echo "${SKARNET_SYSDEPS_DIR}"                       > ${S6PORTABLE_UTILS_CONF_COMPILE}/conf-install-sysdeps &&
        rm -f ${S6PORTABLE_UTILS_CONF_COMPILE}/flag-slashpackage
    BUILD_COMMAND
        mkdir -p ${S6PORTABLE_UTILS_OUTPUT_DIR}/etc &&
        make -C ${SKA_PKG_DIR}/prog/${S6PORTABLE_UTILS_PACKAGE} 
    INSTALL_COMMAND make -C ${SKA_PKG_DIR}/prog/${S6PORTABLE_UTILS_PACKAGE} install
    )

install(DIRECTORY ${S6PORTABLE_UTILS_OUTPUT_DIR}/include/skarnet 
    DESTINATION ${CONTRIBS_INSTALL_DIR}/include/
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.h"
    )

install(DIRECTORY ${S6PORTABLE_UTILS_OUTPUT_DIR}/library.so/skarnet 
    DESTINATION ${CONTRIBS_INSTALL_DIR}/lib
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.so*"
    )

install(DIRECTORY ${S6PORTABLE_UTILS_OUTPUT_DIR}/etc
    DESTINATION /
    USE_SOURCE_PERMISSIONS
    )

install(DIRECTORY ${S6PORTABLE_UTILS_OUTPUT_DIR}/command
    DESTINATION ${CONTRIBS_INSTALL_DIR}
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*"
    )


include(package.cmake)
