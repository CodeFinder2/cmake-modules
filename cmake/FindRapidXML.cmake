# Try to find RapidXML parsing library. Once done, this will define
#  RapidXML_FOUND - TRUE if RapidXML was found properly
#  RapidXML_INCLUDE_DIRS - the RapidXML include directory
#  RapidXML_LIBRARIES - the RapidXML libraries
#  RapidXML_DEFINITIONS - compiler definitions for RapidXML
#
# Defining the (CMake/environment) variable RAPIDXML_ROOT can help to find it. Since this is a
# header-only library (as of v1.13, 05/04/2017), library related variables are empty. You may also
# want to set RapidXML_FETCH_EXTERNAL to get the sources from GitHub if a system package could not
# be found.
#
# (C) Copyright 2016-2017, Adrian Böckenkamp, 05/04/2017

set(INCLUDE_BASE_DIR "rapidxml")

find_path(RapidXML_INCLUDE_DIRS
  NAMES ${INCLUDE_BASE_DIR}/rapidxml.hpp
  PATHS
  ${RAPIDXML_ROOT} # Prefer CMake variable, ...
  $ENV{RAPIDXML_ROOT} # then search in environment variable, ...
  /usr/include # and then inspect the system path.
  /usr/include
  /usr/local/include
  /usr/local/include
  DOC "RapidXML header directory location"
  NO_DEFAULT_PATH
)

# Indicate that we've found the system variant, so no need to
# add_dependencies(YOUR_TARGET_NAME ${RapidXML_FETCH_EXTERNAL})
if (RapidXML_INCLUDE_DIRS AND RapidXML_FETCH_EXTERNAL)
  unset(RapidXML_FETCH_EXTERNAL)
endif()

if (RapidXML_FETCH_EXTERNAL)
  include(ExternalProject)
  set(PREFIX "${CMAKE_BINARY_DIR}/${RapidXML_FETCH_EXTERNAL}")
  set(SOURCE_DIR "${PREFIX}/${INCLUDE_BASE_DIR}")
  ExternalProject_Add(${RapidXML_FETCH_EXTERNAL}
    PREFIX ${PREFIX}
    URL ${PROJECT_SOURCE_DIR}/../../../3rdparty/rapidxml-1.13.zip
    URL_MD5 7b4b42c9331c90aded23bb55dc725d6a
    SOURCE_DIR ${SOURCE_DIR}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
  )
  set(RapidXML_INCLUDE_DIRS "${PREFIX}")
endif()

if(NOT RapidXML_INCLUDE_DIRS AND NOT DEFINED ENV{RAPIDXML_ROOT} AND NOT RAPIDXML_ROOT AND NOT RapidXML_FIND_QUIETLY)
  message(STATUS "You may want to set RAPIDXML_ROOT (environment) variable to find RapidXML.")
endif()
set(RapidXML_LIBRARIES "")
set(RapidXML_DEFINITIONS "")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RapidXML DEFAULT_MSG RapidXML_INCLUDE_DIRS)

mark_as_advanced(RapidXML_LIBRARIES RapidXML_DEFINITIONS)
