cmake_minimum_required (VERSION 2.8)
project (execline)

set(DEFAULT_INSTALL_DIR ${CMAKE_BINARY_DIR}/.built)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${DEFAULT_INSTALL_DIR}/lib)
#     set(LINK_FLAGS -Xlinker -rpath-link -Xlinker ${DEFAULT_INSTALL_DIR}/lib )
set (EXECUTABLE_OUTPUT_PATH ${DEFAULT_INSTALL_DIR}/bin)
set(CONTRIBS_INSTALL_DIR /usr/share)

include(project_ver.cmake)
include(ExternalProject)

# download dirname
set(3RD_DL_DIR ${CMAKE_BINARY_DIR}/../.support)

# execline dirnames
set(SKA_PKG_DIR ${CMAKE_CURRENT_BINARY_DIR}/package)
set(SKARNET_STAGING_DIR ${CMAKE_CURRENT_BINARY_DIR}/../skarnet)
set(SKARNET_SYSDEPS_DIR ${SKARNET_STAGING_DIR}/sysdeps)

set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download configure build install test)

set(EXECLINE_PACKAGE execline-${VERSION_STRING})
set(EXECLINE_CONF_COMPILE ${SKA_PKG_DIR}/prog/${EXECLINE_PACKAGE}/conf-compile)
set(EXECLINE_OUTPUT_DIR ${SKARNET_STAGING_DIR}/execline)

ExternalProject_Add(${PROJECT_NAME}
#    DEPENDS             
    STAMP_DIR           ${CMAKE_BINARY_DIR}/.stamps
    DOWNLOAD_DIR        ${3RD_DL_DIR}
    URL                 http://www.skarnet.org/software/execline/execline-${VERSION_STRING}.tar.gz
    URL_MD5             3913c1ef0b704703fac1271815651c8b
    SOURCE_DIR          "${SKA_PKG_DIR}/prog"
    BUILD_IN_SOURCE     0
    CONFIGURE_COMMAND  
        echo "${SKARNET_SYSDEPS_DIR}"                               > ${EXECLINE_CONF_COMPILE}/import && 
        echo ""                                                     > ${EXECLINE_CONF_COMPILE}/flag-allstatic &&
        echo "${SKARNET_STAGING_DIR}/skalibs/include/skarnet"       > ${EXECLINE_CONF_COMPILE}/path-include && 
        echo "${SKARNET_STAGING_DIR}/skalibs/library/skarnet"       > ${EXECLINE_CONF_COMPILE}/path-library && 
        echo "${SKARNET_STAGING_DIR}/skalibs/library.so/skarnet"    > ${EXECLINE_CONF_COMPILE}/path-library.so && 
        echo "${SKA_PKG_DIR}"                               > ${EXECLINE_CONF_COMPILE}/conf-sp_root &&
        echo "${EXECLINE_OUTPUT_DIR}/command"               > ${EXECLINE_CONF_COMPILE}/conf-install-command && 
        echo "${EXECLINE_OUTPUT_DIR}/library/skarnet"       > ${EXECLINE_CONF_COMPILE}/conf-install-library &&
        echo "${EXECLINE_OUTPUT_DIR}/library.so/skarnet"    > ${EXECLINE_CONF_COMPILE}/conf-install-library.so &&
        echo "${EXECLINE_OUTPUT_DIR}/include/skarnet"       > ${EXECLINE_CONF_COMPILE}/conf-install-include &&
        echo "${EXECLINE_OUTPUT_DIR}/etc"                   > ${EXECLINE_CONF_COMPILE}/conf-etc &&
        echo "${SKARNET_SYSDEPS_DIR}"                       > ${EXECLINE_CONF_COMPILE}/conf-install-sysdeps &&
        rm -f ${EXECLINE_CONF_COMPILE}/flag-slashpackage
    BUILD_COMMAND
        mkdir -p ${EXECLINE_OUTPUT_DIR}/etc &&
        make -C ${SKA_PKG_DIR}/prog/${EXECLINE_PACKAGE} 
    INSTALL_COMMAND make -C ${SKA_PKG_DIR}/prog/${EXECLINE_PACKAGE} install
    )

install(DIRECTORY ${EXECLINE_OUTPUT_DIR}/include/skarnet 
    DESTINATION ${CONTRIBS_INSTALL_DIR}/include/
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.h"
    )

install(DIRECTORY ${EXECLINE_OUTPUT_DIR}/library.so/skarnet 
    DESTINATION ${CONTRIBS_INSTALL_DIR}/lib
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*.so*"
    )

install(DIRECTORY ${EXECLINE_OUTPUT_DIR}/etc
    DESTINATION /
    USE_SOURCE_PERMISSIONS
    )


install(DIRECTORY ${EXECLINE_OUTPUT_DIR}/command
    DESTINATION /
    USE_SOURCE_PERMISSIONS
    FILES_MATCHING PATTERN "*"
    )


include(package.cmake)
