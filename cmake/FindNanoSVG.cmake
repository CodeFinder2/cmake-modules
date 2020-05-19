# Try to fetch NanoSVG (see https://github.com/memononen/nanosvg) library.
# Once done, this will define
#  NanoSVG_FOUND - TRUE if NanoSVG was found properly
#  NanoSVG_INCLUDE_DIRS - the NanoSVG include directory
#  NanoSVG_DEFINITIONS - compiler flags required to use NanoSVG
#  NanoSVG_LIBRARIES - library files for NanoSVG
#
# Defining the (CMake/environment) variable NANOSVG_ROOT can help to find it. Since this
# is a header-only library (as of version 46c7ae0), library related variables are empty. You may
# also want to set NanoSVG_FETCH_EXTERNAL to get the sources from GitHub if a system
# package could not be found. Since there is no known package on popular Linux systems, this is
# set to "nanosvg" on default.
#
# (C) Copyright 2017, Adrian Böckenkamp, 05/04/2017

if (NOT DEFINED NanoSVG_FETCH_EXTERNAL)
  set(NanoSVG_FETCH_EXTERNAL "nanosvg")
endif()

find_path(NanoSVG_INCLUDE_DIRS
  NAMES nanosvg.h
  PATHS
  ${NANOSVG_ROOT} # Prefer CMake variable, ...
  $ENV{NANOSVG_ROOT} # then search in environment variable, ...
  /usr/include # and then inspect the system path.
  /usr/local/include
  DOC "NanoSVG header directory location"
  NO_DEFAULT_PATH
)

# Indicate that we've found the system variant, so no need to
# add_dependencies(YOUR_TARGET_NAME ${NanoSVG_FETCH_EXTERNAL})
if (NanoSVG_INCLUDE_DIRS AND NanoSVG_FETCH_EXTERNAL)
  unset(NanoSVG_FETCH_EXTERNAL)
endif()

if (NanoSVG_FETCH_EXTERNAL)
  include(ExternalProject)
  set(PREFIX "${CMAKE_BINARY_DIR}/${NanoSVG_FETCH_EXTERNAL}")
  set(SOURCE_DIR "${PREFIX}/src/${NanoSVG_FETCH_EXTERNAL}")
  ExternalProject_Add(${NanoSVG_FETCH_EXTERNAL}
    PREFIX ${PREFIX}
    SOURCE_DIR ${SOURCE_DIR}
    GIT_REPOSITORY https://github.com/memononen/nanosvg
    GIT_TAG master
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
  set(NanoSVG_INCLUDE_DIRS "${SOURCE_DIR}/src")
endif()

if(NOT NanoSVG_INCLUDE_DIRS AND NOT DEFINED ENV{NANOSVG_ROOT} AND
   NOT NANOSVG_ROOT AND NOT NanoSVG_FIND_QUIETLY)
  message(STATUS "You may want to set NANOSVG_ROOT (environment) variable to find NanoSVG.")
endif()

set(NanoSVG_DEFINITIONS -DNANOSVG_IMPLEMENTATION) # possibly also add -DNANOSVG_ALL_COLOR_KEYWORDS
set(NanoSVG_LIBRARIES "")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NanoSVG DEFAULT_MSG NanoSVG_INCLUDE_DIRS NanoSVG_DEFINITIONS)

mark_as_advanced(NanoSVG_LIBRARIES NanoSVG_DEFINITIONS NanoSVG_DEFINITIONS)
