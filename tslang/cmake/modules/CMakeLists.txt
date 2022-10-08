include(ExtendPath)
include(FindPrefixFromConfig)

# Generate a list of CMake library targets so that other CMake projects can
# link against them. LLVM calls its version of this file LLVMExports.cmake, but
# the usual CMake convention seems to be ${Project}Targets.cmake.
set(TSLANG_INSTALL_PACKAGE_DIR lib${LLVM_LIBDIR_SUFFIX}/cmake/tslang)
set(tslang_cmake_builddir "${CMAKE_BINARY_DIR}/${TSLANG_INSTALL_PACKAGE_DIR}")

# Keep this in sync with llvm/cmake/CMakeLists.txt!
set(LLVM_INSTALL_PACKAGE_DIR lib${LLVM_LIBDIR_SUFFIX}/cmake/llvm)
set(llvm_cmake_builddir "${LLVM_BINARY_DIR}/${LLVM_INSTALL_PACKAGE_DIR}")

get_property(TSLANG_EXPORTS GLOBAL PROPERTY TSLANG_EXPORTS)
export(TARGETS ${TSLANG_EXPORTS} FILE ${tslang_cmake_builddir}/TSlangTargets.cmake)

# Generate TSlangConfig.cmake for the build tree.
set(TSLANG_CONFIG_CMAKE_DIR "${tslang_cmake_builddir}")
set(TSLANG_CONFIG_LLVM_CMAKE_DIR "${llvm_cmake_builddir}")
set(TSLANG_CONFIG_INCLUDE_EXPORTS "include(\"${tslang_cmake_builddir}/TSlangTargets.cmake\")")
set(TSLANG_CONFIG_INCLUDE_DIRS
  "${TSLANG_SOURCE_DIR}/include"
  "${TSLANG_BINARY_DIR}/include"
  )
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/TSlangConfig.cmake.in
  ${tslang_cmake_builddir}/TSlangConfig.cmake
  @ONLY)
set(TSLANG_CONFIG_CMAKE_DIR)
set(TSLANG_CONFIG_LLVM_CMAKE_DIR)

# Generate TSlangConfig.cmake for the install tree.
find_prefix_from_config(TSLANG_CONFIG_CODE TSLANG_INSTALL_PREFIX "${TSLANG_INSTALL_PACKAGE_DIR}")

set(TSLANG_CONFIG_CMAKE_DIR "\${TSLANG_INSTALL_PREFIX}/${TSLANG_INSTALL_PACKAGE_DIR}")
set(TSLANG_CONFIG_LLVM_CMAKE_DIR "\${TSLANG_INSTALL_PREFIX}/${LLVM_INSTALL_PACKAGE_DIR}")
get_config_exports_includes(TSlang TSLANG_CONFIG_INCLUDE_EXPORTS)
extend_path(TSLANG_CONFIG_INCLUDE_DIRS "\${TSLANG_INSTALL_PREFIX}" "${CMAKE_INSTALL_INCLUDEDIR}")

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/TSlangConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/TSlangConfig.cmake
  @ONLY)

set(TSLANG_CONFIG_CODE)
set(TSLANG_CONFIG_CMAKE_DIR)
set(TSLANG_CONFIG_EXPORTS_FILE)

if (NOT LLVM_INSTALL_TOOLCHAIN_ONLY)
  install_distribution_exports(TSlang)

  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/TSlangConfig.cmake
    DESTINATION ${TSLANG_INSTALL_PACKAGE_DIR}
    COMPONENT tslang-cmake-exports)

  if(NOT LLVM_ENABLE_IDE)
    # Add a dummy target so this can be used with LLVM_DISTRIBUTION_COMPONENTS
    add_custom_target(tslang-cmake-exports)
    add_llvm_install_targets(install-tslang-cmake-exports
                             COMPONENT tslang-cmake-exports)
  endif()
endif()
