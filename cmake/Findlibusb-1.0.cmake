# - Try to find libusb-1.0
# Once done this will define
#
#  LIBUSB_1_FOUND - system has libusb
#  LIBUSB_1_INCLUDE_DIRS - the libusb include directory
#  LIBUSB_1_LIBRARIES - Link these to use libusb
#  LIBUSB_1_DEFINITIONS - Compiler switches required for using libusb
#
#  Adapted from cmake-modules Google Code project
#
#  Copyright (c) 2006 Andreas Schneider <mail@cynapses.org>
#
#  (Changes for libusb) Copyright (c) 2008 Kyle Machulis <kyle@nonpolynomial.com>
#
# Redistribution and use is allowed according to the terms of the New BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#


if (LIBUSB_1_LIBRARIES AND LIBUSB_1_INCLUDE_DIRS)
  # in cache already
  set(LIBUSB_FOUND TRUE)
else (LIBUSB_1_LIBRARIES AND LIBUSB_1_INCLUDE_DIRS)
  find_path(LIBUSB_1_INCLUDE_DIR
    NAMES
	  libusb.h
    PATHS
      /usr/include
      /usr/local/include
      /opt/local/include
      /sw/include
      $ENV{LIBUSB_1_ROOT}/include
	PATH_SUFFIXES
	  libusb-1.0
  )
  
  set(LIBUSB_1_LIBRARY_PATH_SUFFIX "")
  if ( ${CMAKE_SYSTEM_NAME} STREQUAL "Windows" )
    # libusb binary distribution contains several libs.
    # Use the lib that got compiled with the same compiler.
    if ( MSVC )
      if (CMAKE_SIZEOF_VOID_P EQUAL 4) # 32 bit
        set ( LIBUSB_1_LIBRARY_PATH_SUFFIX MS32/dll )
      else () # 64 bit
        set ( LIBUSB_1_LIBRARY_PATH_SUFFIX MS64/dll )
      endif ()          
    endif ()
  endif ( ${CMAKE_SYSTEM_NAME} STREQUAL "Windows" )

  find_library(LIBUSB_1_LIBRARY
    NAMES
      libusb-1.0 usb-1.0
    PATHS
      /usr/lib
      /usr/local/lib
      /opt/local/lib
      /sw/lib
      $ENV{LIBUSB_1_ROOT}
    PATH_SUFFIXES
      ${LIBUSB_1_LIBRARY_PATH_SUFFIX}
  )
  # Note: find_library also checks the $PATH env. variable
  #       (before looking at $LIBUSB_1_ROOT)!

  set(LIBUSB_1_INCLUDE_DIRS ${LIBUSB_1_INCLUDE_DIR}
  )
  set(LIBUSB_1_LIBRARIES ${LIBUSB_1_LIBRARY}
)

  if (LIBUSB_1_INCLUDE_DIRS AND LIBUSB_1_LIBRARIES)
     set(LIBUSB_1_FOUND TRUE)
  endif (LIBUSB_1_INCLUDE_DIRS AND LIBUSB_1_LIBRARIES)

  if (LIBUSB_1_FOUND)
    if (NOT libusb_1_FIND_QUIETLY)
      message(STATUS "Found libusb-1.0:")
	  message(STATUS " - Includes: ${LIBUSB_1_INCLUDE_DIRS}")
	  message(STATUS " - Libraries: ${LIBUSB_1_LIBRARIES}")
    endif (NOT libusb_1_FIND_QUIETLY)
  else (LIBUSB_1_FOUND)
    if (libusb_1_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find libusb")
    endif (libusb_1_FIND_REQUIRED)
  endif (LIBUSB_1_FOUND)

  # show the LIBUSB_1_INCLUDE_DIRS and LIBUSB_1_LIBRARIES variables only in the advanced view
  mark_as_advanced(LIBUSB_1_INCLUDE_DIRS LIBUSB_1_LIBRARIES)

endif (LIBUSB_1_LIBRARIES AND LIBUSB_1_INCLUDE_DIRS)
