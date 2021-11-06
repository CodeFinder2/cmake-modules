# Try to fetch Spdlog (see https://github.com/gabime/spdlog) library.
# Once done, this will define
#  Spdlog_FOUND - TRUE if Spdlog was found properly
#  Spdlog_INCLUDE_DIRS - the Spdlog include directory
#  Spdlog_DEFINITIONS - compiler flags required to use Spdlog
#  Spdlog_LIBRARIES - library files for Spdlog
#
# Defining the (CMake/environment) variable SPDLOG_ROOT can help to find it. Since this
# is a header-only library (as of version 58e7f68), library related variables are empty. You may
# also want to set Spdlog_FETCH_EXTERNAL to get the sources from GitHub if a system
# package could not be found or you want the most recent Github version.
#
# (C) Copyright 2021, Adrian Böckenkamp, 17/08/2021

if (NOT DEFINED Spdlog_FETCH_EXTERNAL)
  find_path(Spdlog_INCLUDE_DIRS
    NAMES spdlog.h
    PATH_SUFFIXES spdlog
    PATHS
    ${SPDLOG_ROOT} # Prefer CMake variable, ...
    $ENV{SPDLOG_ROOT} # then search in environment variable, ...
    /usr/include # and then inspect the system path.
    /usr/local/include
    DOC "Spdlog header directory location"
    NO_DEFAULT_PATH
  )
endif()

if (NOT DEFINED Spdlog_DEFINITIONS)
  set(Spdlog_DEFINITIONS "")
endif()

if (Spdlog_FETCH_EXTERNAL)
  if (TARGET ${Spdlog_FETCH_EXTERNAL})
    get_property(Spdlog_INCLUDE_DIRS TARGET ${Spdlog_FETCH_EXTERNAL} PROPERTY INCLUDE_DIRECTORIES)
    get_property(Spdlog_LIBRARIES TARGET ${Spdlog_FETCH_EXTERNAL} PROPERTY LINK_LIBRARIES)
    get_property(Spdlog_DEFINITIONS TARGET ${Spdlog_FETCH_EXTERNAL} PROPERTY COMPILE_DEFINITIONS)
  else()
    set(Spdlog_DEFINITIONS "")
    set(Spdlog_LIBRARIES "")

    include(ExternalProject)
    set(PREFIX "${CMAKE_BINARY_DIR}/${Spdlog_FETCH_EXTERNAL}")
    set(SOURCE_DIR "${PREFIX}/src/${Spdlog_FETCH_EXTERNAL}")
    ExternalProject_Add(${Spdlog_FETCH_EXTERNAL}
      PREFIX ${PREFIX}
      UPDATE_DISCONNECTED 1
      SOURCE_DIR ${SOURCE_DIR}
      GIT_REPOSITORY https://github.com/gabime/spdlog
      GIT_TAG "v1.9.2"
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )
    set(Spdlog_INCLUDE_DIRS "${SOURCE_DIR}/include")
    set_target_properties(${Spdlog_FETCH_EXTERNAL} PROPERTIES INCLUDE_DIRECTORIES "${Spdlog_INCLUDE_DIRS}")
    set_target_properties(${Spdlog_FETCH_EXTERNAL} PROPERTIES LINK_LIBRARIES "${Spdlog_LIBRARIES}")
    set_target_properties(${Spdlog_FETCH_EXTERNAL} PROPERTIES COMPILE_DEFINITIONS "${Spdlog_DEFINITIONS}")
  endif()
endif()

if(NOT Spdlog_INCLUDE_DIRS AND NOT DEFINED ENV{SPDLOG_ROOT} AND
   NOT SPDLOG_ROOT AND NOT Spdlog_FIND_QUIETLY)
  message(STATUS "You may want to set SPDLOG_ROOT (environment) variable to find Spdlog.")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Spdlog DEFAULT_MSG Spdlog_INCLUDE_DIRS)

mark_as_advanced(Spdlog_LIBRARIES Spdlog_DEFINITIONS)
