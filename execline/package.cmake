
SET(LTIME_VERSION ${${PROJECT_NAME}_VERSION_LIFETIME})
SET(MAJOR_VERSION ${${PROJECT_NAME}_VERSION_MAJOR})
SET(MINOR_VERSION ${${PROJECT_NAME}_VERSION_MINOR})
SET(PATCH_VERSION ${${PROJECT_NAME}_VERSION_RELEASE})

IF(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")
INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_INSTALL_PREFIX /usr)
SET(CPACK_SET_DESTDIR "on")
SET(CPACK_PACKAGING_INSTALL_PREFIX "/tmp")
SET(CPACK_GENERATOR "TGZ;DEB")

SET(CPACK_PACKAGE_DESCRIPTION "Execline software")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "A small scripting language, to be used in place of a shell in non-interactive scripts." ) 
SET(CPACK_PACKAGE_VENDOR "Aquaplouf Land")
SET(CPACK_PACKAGE_CONTACT "Vincent de RIBOU <belzo2005-dolphin@yahoo.fr>")
SET(CPACK_PACKAGE_VERSION_MAJOR "${LTIME_VERSION}")
SET(CPACK_PACKAGE_VERSION_MINOR "${MAJOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_PATCH "${MINOR_VERSION}.${PATCH_VERSION}")
SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${LTIME_VERSION}_${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}_${CMAKE_SYSTEM_PROCESSOR}")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_FILE_NAME}")

SET(CPACK_DEBIAN_PACKAGE_DEPENDS "skalibs (>=1.6.0.0)")
SET(CPACK_DEBIAN_PACKAGE_CONFLICTS "")

SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
SET(CPACK_DEBIAN_PACKAGE_SECTION "misc")
SET(CPACK_DEBIAN_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})

SET(CPACK_COMPONENTS_ALL Libraries ApplicationData)
INCLUDE(CPack)

ENDIF(EXISTS "${CMAKE_ROOT}/Modules/CPack.cmake")

