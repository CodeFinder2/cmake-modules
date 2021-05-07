# Try to fetch SimpleSVG (see https://github.com/adishavit/simple-svg) library.
# Once done, this will define
#  SimpleSVG_FOUND - TRUE if SimpleSVG was found properly
#  SimpleSVG_INCLUDE_DIRS - the SimpleSVG include directory
#  SimpleSVG_DEFINITIONS - compiler flags required to use SimpleSVG
#  SimpleSVG_LIBRARIES - library files for SimpleSVG
#
# Defining the (CMake/environment) variable SIMPLESVG_ROOT can help to find it. Since this
# is a header-only library (as of version 46c7ae0), library related variables are empty. You may
# also want to set SimpleSVG_FETCH_EXTERNAL to get the sources from GitHub if a system
# package could not be found. Since there is no known package on popular Linux systems, this is
# set to "simplesvg" on default.
#
# (C) Copyright 2017-2021, Adrian Böckenkamp, 15/04/2021

if (NOT DEFINED SimpleSVG_FETCH_EXTERNAL)
  set(SimpleSVG_FETCH_EXTERNAL "simplesvg")
endif()

find_path(SimpleSVG_INCLUDE_DIRS
  NAMES simple_svg_1.0.0.hpp
  PATHS
  ${SIMPLESVG_ROOT} # Prefer CMake variable, ...
  $ENV{SIMPLESVG_ROOT} # then search in environment variable, ...
  /usr/include # and then inspect the system path.
  /usr/local/include
  DOC "SimpleSVG header directory location"
  NO_DEFAULT_PATH
)

# Indicate that we've found the system variant, so no need to
# add_dependencies(YOUR_TARGET_NAME ${SimpleSVG_FETCH_EXTERNAL})
if (SimpleSVG_INCLUDE_DIRS AND SimpleSVG_FETCH_EXTERNAL)
  unset(SimpleSVG_FETCH_EXTERNAL)
endif()

if (SimpleSVG_FETCH_EXTERNAL)
  if (TARGET ${SimpleSVG_FETCH_EXTERNAL})
    get_property(SimpleSVG_INCLUDE_DIRS TARGET ${SimpleSVG_FETCH_EXTERNAL} PROPERTY INCLUDE_DIRECTORIES)
    get_property(SimpleSVG_LIBRARIES TARGET ${SimpleSVG_FETCH_EXTERNAL} PROPERTY LINK_LIBRARIES)
    get_property(SimpleSVG_DEFINITIONS TARGET ${SimpleSVG_FETCH_EXTERNAL} PROPERTY COMPILE_DEFINITIONS)
  else()
    set(SimpleSVG_DEFINITIONS -DSIMPLESVG_IMPLEMENTATION -DSIMPLESVG_ALL_COLOR_KEYWORDS)
    set(SimpleSVG_LIBRARIES "")

    include(ExternalProject)
    set(PREFIX "${CMAKE_BINARY_DIR}/${SimpleSVG_FETCH_EXTERNAL}")
    set(SOURCE_DIR "${PREFIX}/src/${SimpleSVG_FETCH_EXTERNAL}")
    ExternalProject_Add(${SimpleSVG_FETCH_EXTERNAL}
      PREFIX ${PREFIX}
      UPDATE_DISCONNECTED 1
      SOURCE_DIR ${SOURCE_DIR}
      GIT_REPOSITORY https://github.com/CodeFinder2/simple-svg
      GIT_TAG master
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )
    set(SimpleSVG_INCLUDE_DIRS "${SOURCE_DIR}")
    set_target_properties(${SimpleSVG_FETCH_EXTERNAL} PROPERTIES INCLUDE_DIRECTORIES "${SimpleSVG_INCLUDE_DIRS}")
    set_target_properties(${SimpleSVG_FETCH_EXTERNAL} PROPERTIES LINK_LIBRARIES "${SimpleSVG_LIBRARIES}")
    set_target_properties(${SimpleSVG_FETCH_EXTERNAL} PROPERTIES COMPILE_DEFINITIONS "${SimpleSVG_DEFINITIONS}")
  endif()
endif()

if(NOT SimpleSVG_INCLUDE_DIRS AND NOT DEFINED ENV{SIMPLESVG_ROOT} AND
   NOT SIMPLESVG_ROOT AND NOT SimpleSVG_FIND_QUIETLY)
  message(STATUS "You may want to set SIMPLESVG_ROOT (environment) variable to find SimpleSVG.")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SimpleSVG DEFAULT_MSG SimpleSVG_INCLUDE_DIRS SimpleSVG_DEFINITIONS)

mark_as_advanced(SimpleSVG_LIBRARIES SimpleSVG_DEFINITIONS SimpleSVG_DEFINITIONS)
