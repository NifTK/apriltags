cmake_minimum_required(VERSION 2.6)
project(apriltags)

configure_file(${CMAKE_SOURCE_DIR}/cmake/FindEIGEN.cmake
  ${CMAKE_BINARY_DIR}/FindEIGEN.cmake @ONLY)

set(CMAKE_MODULE_PATH
    ${CMAKE_BINARY_DIR}
    ${CMAKE_MODULE_PATH}
   )

file(GLOB SOURCE_FILES "src/*.cc")
include_directories(AprilTags . )
add_library(apriltags ${SOURCE_FILES})

find_package(EIGEN REQUIRED)
include_directories(${EIGEN_INCLUDE_DIR})

find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(apriltags ${OpenCV_LIBS}) #-pg) #-fopenmp)

#add_subdirectory(example)

# Add stuff for an install target.
file(GLOB HEADER_FILES ${CMAKE_SOURCE_DIR}/AprilTags/*)
install(PROGRAMS ${HEADER_FILES} DESTINATION include/AprilTags COMPONENT applications)
find_library(APRILTAGS_LIB
  apriltags
  PATHS ${CMAKE_BINARY_DIR}
  NO_DEFAULT_PATH
  ) 
install(PROGRAMS ${APRILTAGS_LIB} DESTINATION lib COMPONENT applications)
