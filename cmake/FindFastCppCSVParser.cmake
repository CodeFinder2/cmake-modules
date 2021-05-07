# Try to find FastCppCSVParser (see https://github.com/ben-strasser/fast-cpp-csv-parser) parsing
# library. Once done, this will define
#  FastCppCSVParser_FOUND - TRUE if FastCppCSVParser was found properly
#  FastCppCSVParser_INCLUDE_DIRS - the FastCppCSVParser include directory
#  FastCppCSVParser_LINKER_FLAGS - linker flags required to use FastCppCSVParser
#  FastCppCSVParser_DEFINITIONS - compiler definitions required to use FastCppCSVParser
#  FastCppCSVParser_LIBRARIES - library files required to use FastCppCSVParser
#
# Defining the (CMake/environment) variable FASTCPPCSVPARSER_ROOT can help to find it. Since this
# is a header-only library (as of version 769c042), library related variables are empty. You may
# also want to set FastCppCSVParser_FETCH_EXTERNAL to get the sources from GitHub if a system
# package could not be found.
#
# (C) Copyright 2016-2017, Adrian Böckenkamp, 05/04/2017

set(INCLUDE_BASE_DIR "fastcppcsvparser")

find_path(FastCppCSVParser_INCLUDE_DIRS
  NAMES ${INCLUDE_BASE_DIR}/csv.h
  PATHS
  ${FASTCPPCSVPARSER_ROOT} # Prefer CMake variable, ...
  $ENV{FASTCPPCSVPARSER_ROOT} # then search in environment variable, ...
  /usr/include # and then inspect the system path.
  /usr/local/include
  DOC "Fast C++ CSV Parser header directory location"
  NO_DEFAULT_PATH
)

# Indicate that we've found the system variant, so no need to
# add_dependencies(YOUR_TARGET_NAME ${FastCppCSVParser_FETCH_EXTERNAL})
if (FastCppCSVParser_INCLUDE_DIRS AND FastCppCSVParser_FETCH_EXTERNAL)
  unset(FastCppCSVParser_FETCH_EXTERNAL)
endif()

if (FastCppCSVParser_FETCH_EXTERNAL)
  if (TARGET ${FastCppCSVParser_FETCH_EXTERNAL})
    get_property(FastCppCSVParser_INCLUDE_DIRS TARGET ${FastCppCSVParser_FETCH_EXTERNAL} PROPERTY INCLUDE_DIRECTORIES)
    get_property(FastCppCSVParser_LIBRARIES TARGET ${FastCppCSVParser_FETCH_EXTERNAL} PROPERTY LINK_LIBRARIES)
    get_property(FastCppCSVParser_DEFINITIONS TARGET ${FastCppCSVParser_FETCH_EXTERNAL} PROPERTY COMPILE_DEFINITIONS)
  else()
    set(FastCppCSVParser_DEFINITIONS "")
    set(FastCppCSVParser_LIBRARIES "")

    include(ExternalProject)
    set(PREFIX "${CMAKE_BINARY_DIR}/${FastCppCSVParser_FETCH_EXTERNAL}")
    set(SOURCE_DIR "${PREFIX}/src/${INCLUDE_BASE_DIR}")
    ExternalProject_Add(${FastCppCSVParser_FETCH_EXTERNAL}
      PREFIX ${PREFIX}
      UPDATE_DISCONNECTED 1
      GIT_REPOSITORY https://github.com/ben-strasser/fast-cpp-csv-parser.git
      SOURCE_DIR ${SOURCE_DIR}
      GIT_TAG master
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
    )
    set(FastCppCSVParser_INCLUDE_DIRS "${PREFIX}/src")
    set_target_properties(${FastCppCSVParser_FETCH_EXTERNAL} PROPERTIES INCLUDE_DIRECTORIES "${FastCppCSVParser_INCLUDE_DIRS}")
    set_target_properties(${FastCppCSVParser_FETCH_EXTERNAL} PROPERTIES LINK_LIBRARIES "${FastCppCSVParser_LIBRARIES}")
    set_target_properties(${FastCppCSVParser_FETCH_EXTERNAL} PROPERTIES COMPILE_DEFINITIONS "${FastCppCSVParser_DEFINITIONS}")
  endif()
endif()

# FastCppCSVParser requires pthreads:
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
if(FastCppCSVParser_FIND_REQUIRED)
  find_package(Threads REQUIRED)
else()
  find_package(Threads)
endif()

if(NOT FastCppCSVParser_INCLUDE_DIRS AND NOT DEFINED ENV{FASTCPPCSVPARSER_ROOT} AND
   NOT FASTCPPCSVPARSER_ROOT AND NOT FastCppCSVParser_FIND_QUIETLY)
  message(STATUS "You may want to set FASTCPPCSVPARSER_ROOT (environment) variable to find Fast C++ CSV Parser.")
endif()

if(CMAKE_USE_PTHREADS_INIT)
  set(FastCppCSVParser_LINKER_FLAGS ${CMAKE_THREAD_LIBS_INIT})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FastCppCSVParser DEFAULT_MSG FastCppCSVParser_INCLUDE_DIRS
  FastCppCSVParser_LINKER_FLAGS)

mark_as_advanced(FastCppCSVParser_DEFINITIONS FastCppCSVParser_LIBRARIES
  FastCppCSVParser_LINKER_FLAGS
)
