cmake_minimum_required(VERSION 3.28)
project(waveform_viewer_library VERSION 0.0.1 LANGUAGES CXX)
include(FetchContent)
set(CMAKE_OSX_DEPLOYMENT_TARGET 10.11)

set(LIBRARY_SRC 
    plot_utilities.c)
set(LIBRARY_HEADER_FILES
    plot_utilities_native.h)

if (CMAKE_SYSTEM_NAME STREQUAL "Darwin" OR CMAKE_SYSTEM_NAME STREQUAL "iOS")
   if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
      set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")
   endif()
   add_library(waveform_viewer_library STATIC ${LIBRARY_SRC})
else()
   add_library(waveform_viewer_library SHARED ${LIBRARY_SRC})
endif()

set_target_properties(waveform_viewer_library PROPERTIES 
                      OUTPUT_NAME "waveform_viewer"
                      CXX_STANDARD 20
                      CXX_STANDARD_REQUIRED YES
                      CXX_EXTENSIONS NO)
target_compile_definitions(waveform_viewer_library PUBLIC DART_SHARED_LIB)
target_include_directories(waveform_viewer_library 
                           PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR})
target_sources(waveform_viewer_library
               PUBLIC 
               FILE_SET HEADERS
               BASE_DIRS
                  ${CMAKE_CURRENT_SOURCE_DIR}
               FILES 
                  ${LIBRARY_HEADER_FILES})
