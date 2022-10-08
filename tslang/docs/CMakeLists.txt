
###########################################################################################
# find_package(Doxygen)                                                                   #
# if (DOXYGEN_FOUND)                                                                      #
# if (LLVM_ENABLE_DOXYGEN)                                                                #
#   set(abs_top_srcdir ${CMAKE_CURRENT_SOURCE_DIR})                                       #
#   set(abs_top_builddir ${CMAKE_CURRENT_BINARY_DIR})                                     #
#                                                                                         #
#   if (HAVE_DOT)                                                                         #
#     set(DOT ${LLVM_PATH_DOT})                                                           #
#   endif()                                                                               #
#                                                                                         #
#   if (LLVM_DOXYGEN_EXTERNAL_SEARCH)                                                     #
#     set(enable_searchengine "YES")                                                      #
#     set(searchengine_url "${LLVM_DOXYGEN_SEARCHENGINE_URL}")                            #
#     set(enable_server_based_search "YES")                                               #
#     set(enable_external_search "YES")                                                   #
#     set(extra_search_mappings "${LLVM_DOXYGEN_SEARCH_MAPPINGS}")                        #
#   else()                                                                                #
#     set(enable_searchengine "NO")                                                       #
#     set(searchengine_url "")                                                            #
#     set(enable_server_based_search "NO")                                                #
#     set(enable_external_search "NO")                                                    #
#     set(extra_search_mappings "")                                                       #
#   endif()                                                                               #
#                                                                                         #
#   # If asked, configure doxygen for the creation of a Qt Compressed Help file.          #
#   if (LLVM_ENABLE_DOXYGEN_QT_HELP)                                                      #
#     set(TSLANG_DOXYGEN_QCH_FILENAME "org.llvm.tslang.qch" CACHE STRING                  #
#       "Filename of the Qt Compressed help file")                                        #
#     set(TSLANG_DOXYGEN_QHP_NAMESPACE "org.llvm.tslang" CACHE STRING                     #
#       "Namespace under which the intermediate Qt Help Project file lives")              #
#     set(TSLANG_DOXYGEN_QHP_CUST_FILTER_NAME "TSLANG ${TSLANG_VERSION}" CACHE STRING     #
#       "See http://qt-project.org/doc/qt-4.8/qthelpproject.html#custom-filters")         #
#     set(TSLANG_DOXYGEN_QHP_CUST_FILTER_ATTRS "TSLANG,${TSLANG_VERSION}" CACHE STRING    #
#       "See http://qt-project.org/doc/qt-4.8/qthelpproject.html#filter-attributes")      #
#     set(tslang_doxygen_generate_qhp "YES")                                              #
#     set(tslang_doxygen_qch_filename "${TSLANG_DOXYGEN_QCH_FILENAME}")                   #
#     set(tslang_doxygen_qhp_namespace "${TSLANG_DOXYGEN_QHP_NAMESPACE}")                 #
#     set(tslang_doxygen_qhelpgenerator_path "${LLVM_DOXYGEN_QHELPGENERATOR_PATH}")       #
#     set(tslang_doxygen_qhp_cust_filter_name "${TSLANG_DOXYGEN_QHP_CUST_FILTER_NAME}")   #
#     set(tslang_doxygen_qhp_cust_filter_attrs "${TSLANG_DOXYGEN_QHP_CUST_FILTER_ATTRS}") #
#   else()                                                                                #
#     set(tslang_doxygen_generate_qhp "NO")                                               #
#     set(tslang_doxygen_qch_filename "")                                                 #
#     set(tslang_doxygen_qhp_namespace "")                                                #
#     set(tslang_doxygen_qhelpgenerator_path "")                                          #
#     set(tslang_doxygen_qhp_cust_filter_name "")                                         #
#     set(tslang_doxygen_qhp_cust_filter_attrs "")                                        #
#   endif()                                                                               #
#                                                                                         #
#   option(LLVM_DOXYGEN_SVG                                                               #
#     "Use svg instead of png files for doxygen graphs." OFF)                             #
#   if (LLVM_DOXYGEN_SVG)                                                                 #
#     set(DOT_IMAGE_FORMAT "svg")                                                         #
#   else()                                                                                #
#     set(DOT_IMAGE_FORMAT "png")                                                         #
#   endif()                                                                               #
#                                                                                         #
#   configure_file(${CMAKE_CURRENT_SOURCE_DIR}/doxygen.cfg.in                             #
#     ${CMAKE_CURRENT_BINARY_DIR}/doxygen.cfg @ONLY)                                      #
#                                                                                         #
#   set(abs_top_srcdir)                                                                   #
#   set(abs_top_builddir)                                                                 #
#   set(DOT)                                                                              #
#   set(enable_searchengine)                                                              #
#   set(searchengine_url)                                                                 #
#   set(enable_server_based_search)                                                       #
#   set(enable_external_search)                                                           #
#   set(extra_search_mappings)                                                            #
#   set(tslang_doxygen_generate_qhp)                                                      #
#   set(tslang_doxygen_qch_filename)                                                      #
#   set(tslang_doxygen_qhp_namespace)                                                     #
#   set(tslang_doxygen_qhelpgenerator_path)                                               #
#   set(tslang_doxygen_qhp_cust_filter_name)                                              #
#   set(tslang_doxygen_qhp_cust_filter_attrs)                                             #
#   set(DOT_IMAGE_FORMAT)                                                                 #
#                                                                                         #
#   add_custom_target(doxygen-tslang                                                      #
#     COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/doxygen.cfg               #
#     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}                                       #
#     COMMENT "Generating tslang doxygen documentation." VERBATIM)                        #
#                                                                                         #
#   if (LLVM_BUILD_DOCS)                                                                  #
#    add_dependencies(doxygen doxygen-tslang)                                             #
#   endif()                                                                               #
#                                                                                         #
#   if (NOT LLVM_INSTALL_TOOLCHAIN_ONLY AND LLVM_BUILD_DOCS)                              #
#     install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doxygen/html                          #
#       DESTINATION docs/html)                                                            #
#   endif()                                                                               #
# endif()                                                                                 #
# endif()                                                                                 #
###########################################################################################

########################################
# if (LLVM_ENABLE_SPHINX)              #
#   include(AddSphinxTarget)           #
#   if (SPHINX_FOUND)                  #
#     if (${SPHINX_OUTPUT_HTML})       #
#       add_sphinx_target(html tslang) #
#     endif()                          #
#     if (${SPHINX_OUTPUT_MAN})        #
#       add_sphinx_target(man tslang)  #
#     endif()                          #
#   endif()                            #
# endif()                              #
########################################

