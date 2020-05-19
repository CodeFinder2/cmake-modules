# Try to find Eigen3 library, see http://eigen.tuxfamily.org/
#
# "Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and
#  related algorithms."
# ---------------------------------------------------------------------------------
#
# This module supports requiring a minimum version, e.g. you can do
#   find_package(Eigen3 3.2.0)
# to require version 3.2.0 or newer of Eigen3.
#
# Once done this will define:
# - Eigen3_FOUND - system has Eigen library with correct version
# - Eigen3_INCLUDE_DIRS - the Eigen include directory
# - Eigen3_DEFINITIONS - the Eigen compiler defintions
# - Eigen3_LIBRARIES - Eigen library files (empty, since Eigen is a header-only library)
# - Eigen3_VERSION - Eigen version
#
# Copyright (c) 2006, 2007 Montel Laurent, <montel@kde.org>
# Copyright (c) 2008, 2009 Gael Guennebaud, <g.gael@free.fr>
# Copyright (c) 2009 Benoit Jacob <jacob.benoit.1@gmail.com>
# Copyright (c) 2015 - 2017 Adrian Böckenkamp <adrian.boeckenkamp@tu-dortmund.de>
# Redistribution and use is allowed according to the terms of the 2-clause BSD license.

# Determine version of Eigen on this system and compare it against the min. required version:
macro(_eigen3_check_version)
  file(READ "${Eigen3_INCLUDE_DIRS}/Eigen/src/Core/util/Macros.h" _Eigen3_VERSION_header)

  string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen3_world_version_match "${_Eigen3_VERSION_header}")
  set(EIGEN3_WORLD_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen3_major_version_match "${_Eigen3_VERSION_header}")
  set(EIGEN3_MAJOR_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen3_minor_version_match "${_Eigen3_VERSION_header}")
  set(EIGEN3_MINOR_VERSION "${CMAKE_MATCH_1}")

  set(Eigen3_VERSION ${EIGEN3_WORLD_VERSION}.${EIGEN3_MAJOR_VERSION}.${EIGEN3_MINOR_VERSION})
  if(${Eigen3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
    set(Eigen3_VERSION_OK FALSE)
  else()
    set(Eigen3_VERSION_OK TRUE)
  endif()

  if(NOT Eigen3_VERSION_OK)
    message(STATUS "Eigen3 version ${Eigen3_VERSION} found in ${Eigen3_INCLUDE_DIRS}, "
            "but at least version ${Eigen3_FIND_VERSION} is required")
  endif()
endmacro(_eigen3_check_version)


if(NOT Eigen3_FIND_VERSION)
  if(NOT Eigen3_FIND_VERSION_MAJOR)
    set(Eigen3_FIND_VERSION_MAJOR 3)
  endif()
  if(NOT Eigen3_FIND_VERSION_MINOR)
    set(Eigen3_FIND_VERSION_MINOR 2)
  endif()
  if(NOT Eigen3_FIND_VERSION_PATCH)
    set(Eigen3_FIND_VERSION_PATCH 0)
  endif()

  set(Eigen3_FIND_VERSION "${Eigen3_FIND_VERSION_MAJOR}.${Eigen3_FIND_VERSION_MINOR}.${Eigen3_FIND_VERSION_PATCH}")
endif()

find_path(Eigen3_INCLUDE_DIRS NAMES signature_of_eigen3_matrix_library
  PATHS
  $ENV{EIGEN3_ROOT}
  ${EIGEN3_ROOT}
  $ENV{EIGEN_ROOT} # just for compatibility
  $ENV{Eigen3_INCLUDE_DIRS}
  ${Eigen3_INCLUDE_DIRS}
  ${CMAKE_INSTALL_PREFIX}/include
  ${KDE4_INCLUDE_DIR}
  PATH_SUFFIXES eigen3 eigen
  # NO_CMAKE_SYSTEM_PATH # prefer custom Eigen library (you may want to omit this)
)

if(NOT Eigen3_INCLUDE_DIRS AND NOT DEFINED ENV{EIGEN3_ROOT} AND NOT Eigen3_FIND_QUIETLY)
  message(STATUS "You may want to set EIGEN3_ROOT (environment) variable to find Eigen.")
endif()

if(Eigen3_INCLUDE_DIRS)
  _eigen3_check_version()
endif()
set(Eigen3_DEFINITIONS "")
set(Eigen3_LIBRARIES "")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Eigen3 DEFAULT_MSG Eigen3_INCLUDE_DIRS Eigen3_VERSION_OK)

mark_as_advanced(Eigen3_VERSION_OK Eigen3_DEFINITIONS Eigen3_LIBRARIES Eigen3_VERSION)
