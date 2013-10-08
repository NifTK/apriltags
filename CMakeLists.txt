cmake_minimum_required(VERSION 2.6)
project(apriltags)

#add_definitions(-pg) #"-fopenmp)

# pull in the pods macros. See cmake/pods.cmake for documentation
set(POD_NAME apriltags)
include(cmake/pods.cmake)

file(GLOB SOURCE_FILES "src/*.cc")
include_directories(AprilTags . /opt/local/include)
add_library(apriltags ${SOURCE_FILES})

# working around on annoying OpenCV 2.4 bug that renders pkgconfig useless (reason: malformed --libs)
# without this bug would just need to add "opencv" to pods_use_pkg_config_packages below)
set(OpenCV_DIR ${PROJECT_SOURCE_DIR}/cmake)
find_package(OpenCV)
include_directories(${OpenCV_INCLUDE_DIRS})
target_link_libraries(apriltags ${OpenCV_LIBS}) #-pg) #-fopenmp)
target_link_libraries(apriltags -L/opt/local/lib/) # MacPorts special treatment...

pods_use_pkg_config_packages(apriltags eigen3)
if (NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin") # v4l not available on Mac
  pods_use_pkg_config_packages(apriltags libv4l2)
endif ()

pods_install_libraries(apriltags)

file(GLOB header_files "AprilTags/*.h")
pods_install_headers(${header_files} DESTINATION AprilTags/)

pods_install_pkg_config_file(apriltags
    LIBS -lapriltags
    REQUIRES eigen3 #opencv
    VERSION 1.0.0)

add_subdirectory(example)
