if(PROJECT_IS_TOP_LEVEL)
  set(CMAKE_INSTALL_INCLUDEDIR
      "include/cmake-init-modules-${PROJECT_VERSION}"
      CACHE PATH "")
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# find_package(<package>) call for consumers to find this project
set(package cmake-init-modules)

# cmake-format: off
install(TARGETS cmake-init-modules_cmake-init-modules
  EXPORT cmake-init-modulesTargets
  RUNTIME COMPONENT cmake-init-modules_Runtime
  LIBRARY COMPONENT cmake-init-modules_Runtime NAMELINK_COMPONENT cmake-init-modules_Development
  ARCHIVE COMPONENT cmake-init-modules_Development
  INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
  FILE_SET HEADERS
)
# cmake-format: on

write_basic_package_version_file("${package}ConfigVersion.cmake"
                                 COMPATIBILITY SameMajorVersion)

# Allow package maintainers to freely override the path for the configs
set(cmake-init-modules_INSTALL_CMAKEDIR
    "${CMAKE_INSTALL_LIBDIR}/cmake/${package}"
    CACHE PATH "CMake package config location relative to the install prefix")
mark_as_advanced(cmake-init-modules_INSTALL_CMAKEDIR)

install(
  FILES cmake/install-config.cmake
  DESTINATION "${cmake-init-modules_INSTALL_CMAKEDIR}"
  RENAME "${package}Config.cmake"
  COMPONENT cmake-init-modules_Development)

install(
  FILES "${PROJECT_BINARY_DIR}/${package}ConfigVersion.cmake"
  DESTINATION "${cmake-init-modules_INSTALL_CMAKEDIR}"
  COMPONENT cmake-init-modules_Development)

install(
  EXPORT cmake-init-modulesTargets
  NAMESPACE cmake-init-modules::
  DESTINATION "${cmake-init-modules_INSTALL_CMAKEDIR}"
  COMPONENT cmake-init-modules_Development)

if(PROJECT_IS_TOP_LEVEL)
  set(CPACK_GENERATOR TGZ)
  include(CPack)
endif()
