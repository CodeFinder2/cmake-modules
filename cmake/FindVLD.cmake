##########################################################################
# Find VLD (Visual Detection Leak), see https://vld.codeplex.com/
#
#
#  VLD_FOUND       - True if vlib found.  
#  VLD_INCLUDE_DIR - where to find vlib.h
#  VLD_LIBRARY     - List of libraries used for compilation under MSVC
#  VLD_SYMBOLS     - List of symbols to add to compilation
#
# This helper file looks into the environment variable VLDDIR. Otherwise,
# VLD is assumed to be installed in "$ENV{PROGRAMFILES}\\Visual Leak Detector".
#
##########################################################################

# This library is only used with Microsoft Visual Studio
IF(MSVC)
	IF(WIN32)
		IF(NOT EXISTS $ENV{VLDDIR}) 
			SET(ENV{VLDDIR}  "$ENV{PROGRAMFILES}\\Visual Leak Detector")
		ENDIF(NOT EXISTS $ENV{VLDDIR}) 
		MESSAGE(STATUS "VLD is $ENV{VLDDIR}") 
	ENDIF()

	FIND_PATH(VLD_INCLUDE_DIR NAMES "vld.h" PATHS $ENV{VLDDIR} PATH_SUFFIXES "include" "../include/")

	IF(CMAKE_SIZEOF_VOID_P EQUAL 8) # 64 bit?
		FIND_LIBRARY(VLD_LIBRARY NAMES "vld" PATHS $ENV{VLDDIR} PATH_SUFFIXES "lib/Win64" "../lib/Win64/") 
	ELSE() # 32 bit
		FIND_LIBRARY(VLD_LIBRARY NAMES "vld" PATHS $ENV{VLDDIR} PATH_SUFFIXES "lib/Win32" "../lib/Win32/") 
	ENDIF()

	IF(VLD_INCLUDE_DIR AND VLD_LIBRARY)
		SET(VLD_FOUND TRUE)
	ENDIF()

	IF(VLD_FOUND)
		IF(NOT VLD_FIND_QUIETLY)
			MESSAGE(STATUS "Found VLD: ${VLD_LIBRARY}")
			SET(VLD_SYMBOLS "-D_VLD")
		ENDIF(NOT VLD_FIND_QUIETLY)
	ELSE()
		IF(VLD_FIND_REQUIRED)
			MESSAGE(FATAL_ERROR "Could not find VLD!")
		ENDIF()
	ENDIF()
ELSE()
	SET(VLD_FOUND FALSE) # not VS
ENDIF()
