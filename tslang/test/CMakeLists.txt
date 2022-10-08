# Test runner infrastructure for TSlang. This configures the TSlang test trees
# for use by Lit, and delegates to LLVM's lit test handlers.

##################################################
# llvm_canonicalize_cmake_booleans(              #
#   TSLANG_BUILD_EXAMPLES                        #
#   TSLANG_STANDALONE_BUILD                      #
#   LLVM_ENABLE_PLUGINS                          #
# )                                              #
#                                                #
# set(TSLANG_TOOLS_DIR ${TSLANG_BINARY_DIR}/bin) #
##################################################

# FIXME In out-of-tree builds, "SHLIBDIR" is undefined and passing it to
# `configure_lit_site_cfg` leads to a configuration error. This is currently
# only required by plugins/examples, which are not supported in out-of-tree
# builds.
#######################################
# if (TSLANG_STANDALONE_BUILD)        #
#   set(PATHS_FOR_PLUGINS "")         #
# else ()                             #
#   set(PATHS_FOR_PLUGINS "SHLIBDIR") #
# endif ()                            #
#######################################

####################################################
# configure_lit_site_cfg(                          #
#   ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in #
#   ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py    #
#   MAIN_CONFIG                                    #
#   ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py         #
#   PATHS                                          #
#   ${PATHS_FOR_PLUGINS}                           #
# )                                                #
####################################################

#########################################################
# configure_lit_site_cfg(                               #
#   ${CMAKE_CURRENT_SOURCE_DIR}/Unit/lit.site.cfg.py.in #
#   ${CMAKE_CURRENT_BINARY_DIR}/Unit/lit.site.cfg.py    #
#   MAIN_CONFIG                                         #
#   ${CMAKE_CURRENT_SOURCE_DIR}/Unit/lit.cfg.py         #
# )                                                     #
#########################################################

#################################################################
# configure_lit_site_cfg(                                       #
#   ${CMAKE_CURRENT_SOURCE_DIR}/NonGtestUnit/lit.site.cfg.py.in #
#   ${CMAKE_CURRENT_BINARY_DIR}/NonGtestUnit/lit.site.cfg.py    #
#   MAIN_CONFIG                                                 #
#   ${CMAKE_CURRENT_SOURCE_DIR}/NonGtestUnit/lit.cfg.py         #
# )                                                             #
#################################################################

#############################################################################
# set(TSLANG_TEST_PARAMS                                                    #
#   tslang_site_config=${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py)         #
#                                                                           #
# set(TSLANG_TEST_DEPENDS                                                   #
#   tslang-new llvm-config FileCheck count not module_files fir-opt tco bbc #
# )                                                                         #
#                                                                           #
# if (TSLANG_INCLUDE_TESTS)                                                 #
#   if (TSLANG_GTEST_AVAIL)                                                 #
#     list(APPEND TSLANG_TEST_DEPENDS TSlangUnitTests)                      #
#   endif()                                                                 #
# endif()                                                                   #
#                                                                           #
# if (TSLANG_BUILD_EXAMPLES)                                                #
#   list(APPEND TSLANG_TEST_DEPENDS                                         #
#     tslangPrintFunctionNames                                              #
#     tslangOmpReport                                                       #
#     )                                                                     #
# endif ()                                                                  #
#############################################################################

#########################################################################
# add_custom_target(tslang-test-depends DEPENDS ${TSLANG_TEST_DEPENDS}) #
#                                                                       #
# add_lit_testsuite(check-tslang "Running the TSlang regression tests"  #
#   ${CMAKE_CURRENT_BINARY_DIR}                                         #
#   PARAMS ${TSLANG_TEST_PARAMS}                                        #
#   DEPENDS ${TSLANG_TEST_DEPENDS}                                      #
# )                                                                     #
# set_target_properties(check-tslang PROPERTIES FOLDER "Tests")         #
#########################################################################

# In case of standalone builds.
###########################################################
# if (TSLANG_STANDALONE_BUILD)                            #
#   add_lit_testsuites(TSLANG ${CMAKE_CURRENT_BINARY_DIR} #
#     PARAMS ${TSLANG_TEST_PARAMS}                        #
#     DEPENDS ${TSLANG_TEST_DEPENDS})                     #
# else()                                                  #
#   add_lit_testsuites(TSLANG ${CMAKE_CURRENT_SOURCE_DIR} #
#     PARAMS ${TSLANG_TEST_PARAMS}                        #
#     DEPENDS ${TSLANG_TEST_DEPENDS})                     #
# endif()                                                 #
###########################################################
