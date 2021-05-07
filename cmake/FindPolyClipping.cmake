# Try to find PolyClipping aka Clipper (see http://www.angusj.com/delphi/clipper.php) library.
# Once done, this will define
#  PolyClipping_FOUND - TRUE if PolyClipping was found properly
#  PolyClipping_INCLUDE_DIRS - the PolyClipping include directories
#  PolyClipping_LIBRARIES - the PolyClipping libraries
#  PolyClipping_LIBRARY_DIRS - the PolyClipping library linking directories (may be req. for RPATH)
#  PolyClipping_DEFINITIONS - compiler definitions for PolyClipping
#
# Defining the (CMake/environment) variable POLYCLIPPING_ROOT can help to find it. You may also
# want to set PolyClipping_FETCH_EXTERNAL to get the latest sources from GitHub. If this flag is
# set, they are always used and a system package is ignored. You can set PolyClipping_DEFINITIONS to
# change the compile flags for the library. Useful flags may be, e. g., -Duse_int32=1, -Duse_xyz=1,
# -Duse_lines=1 (the default), and -Duse_deprecated=1 (see clipper.hpp header for reference).
#
# (C) Copyright 2017, Adrian Böckenkamp, 24/07/2017

set(INCLUDE_BASE_DIR "polyclipping")

if (PolyClipping_FETCH_EXTERNAL) # prefer the latest GitHub sources
  if (TARGET ${PolyClipping_FETCH_EXTERNAL})
    get_property(PolyClipping_INCLUDE_DIRS TARGET ${PolyClipping_FETCH_EXTERNAL} PROPERTY INCLUDE_DIRECTORIES)
    get_property(PolyClipping_LIBRARIES TARGET ${PolyClipping_FETCH_EXTERNAL} PROPERTY LINK_LIBRARIES)
    get_property(PolyClipping_DEFINITIONS TARGET ${PolyClipping_FETCH_EXTERNAL} PROPERTY COMPILE_DEFINITIONS)
    get_property(PolyClipping_LIBRARY_DIRS TARGET ${PolyClipping_FETCH_EXTERNAL} PROPERTY LINK_DIRECTORIES)
  else()
    if (NOT PolyClipping_DEFINITIONS)
      set(PolyClipping_DEFINITIONS "-Duse_lines=1")
    endif()

    include(ExternalProject)
    set(CLIPPER_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/${PolyClipping_FETCH_EXTERNAL}/install")
    ExternalProject_Add(${PolyClipping_FETCH_EXTERNAL}
      PREFIX ${CMAKE_CURRENT_BINARY_DIR}/${PolyClipping_FETCH_EXTERNAL}
      UPDATE_DISCONNECTED 1
      GIT_REPOSITORY https://github.com/CodeFinder2/clipper.git
      BUILD_COMMAND $(MAKE) COMMAND
        echo "Clipper library compiled successfully."
      GIT_TAG master
      INSTALL_DIR install
      INSTALL_COMMAND $(MAKE) install COMMAND
        echo "Clipper library installed to ${CLIPPER_INSTALL_DIR}"
      # Point CMake to the correct directory containing the CMakeLists.txt file. Since this is only
      # supported in CMake >= v3.7, we copied the modified version of ExternalProject_Add() to the
      # project's cmake/ module directory, see also (can be removed if we make CMake 3.7 min. req.):
      # http://stackoverflow.com/questions/30028117/cmake-externalproject-how-to-specify-relative-path-to-the-root-cmakelists-txt
      SOURCE_SUBDIR cpp
      CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=RELEASE
        -DCMAKE_INSTALL_PREFIX:PATH=${CLIPPER_INSTALL_DIR}
        -DCMAKE_C_FLAGS=-march=native -mtune=native ${PolyClipping_DEFINITIONS}
        -DCMAKE_CXX_FLAGS=-march=native -mtune=native ${PolyClipping_DEFINITIONS}
    )
    set(PolyClipping_INCLUDE_DIRS "${CLIPPER_INSTALL_DIR}/include/")
    set(PolyClipping_LIBRARIES
      "${CLIPPER_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}polyclipping${CMAKE_SHARED_LIBRARY_SUFFIX}")
    set(PolyClipping_LIBRARY_DIRS "${CLIPPER_INSTALL_DIR}/lib/")

    set_target_properties(${PolyClipping_FETCH_EXTERNAL} PROPERTIES INCLUDE_DIRECTORIES "${PolyClipping_INCLUDE_DIRS}")
    set_target_properties(${PolyClipping_FETCH_EXTERNAL} PROPERTIES LINK_LIBRARIES "${PolyClipping_LIBRARIES}")
    set_target_properties(${PolyClipping_FETCH_EXTERNAL} PROPERTIES COMPILE_DEFINITIONS "${PolyClipping_DEFINITIONS}")
    set_target_properties(${PolyClipping_FETCH_EXTERNAL} PROPERTIES LINK_DIRECTORIES "${PolyClipping_LIBRARY_DIRS}")
  endif()
else() # search for the system package
  find_path(PolyClipping_INCLUDE_DIRS
    NAMES clipper.hpp
    PATHS
    ${POLYCLIPPING_ROOT} # Prefer CMake variable, ...
    $ENV{POLYCLIPPING_ROOT} # then search in environment variable, ...
    /usr/include # and then inspect the system paths.
    /usr/local/include
    PATH_SUFFIXES ${INCLUDE_BASE_DIR}
    DOC "PolyClipping (aka Clipper) header directory locations"
    NO_DEFAULT_PATH
  )

  find_library(PolyClipping_LIBRARIES NAMES
    polyclipping libpolyclipping
    PATHS
    ${POLYCLIPPING_ROOT}
    $ENV{POLYCLIPPING_ROOT}
    /usr/lib
    /usr/local/lib
    DOC "PolyClipping (aka Clipper) shared library file paths"
  )
  set(PolyClipping_DEFINITIONS "")
  get_filename_component(PolyClipping_LIBRARY_DIRS ${PolyClipping_LIBRARIES} DIRECTORY)
endif()

if(NOT PolyClipping_INCLUDE_DIRS AND NOT PolyClipping_LIBRARIES AND NOT DEFINED ENV{POLYCLIPPING_ROOT}
   AND NOT PolyClipping_FIND_QUIETLY)
  message(STATUS "You may want to set POLYCLIPPING_ROOT (environment) variable to find PolyClipping.")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PolyClipping DEFAULT_MSG PolyClipping_INCLUDE_DIRS
  PolyClipping_LIBRARIES)

mark_as_advanced(PolyClipping_DEFINITIONS PolyClipping_LIBRARY_DIRS)
