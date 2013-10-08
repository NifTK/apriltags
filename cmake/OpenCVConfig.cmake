# ===================================================================================
#  The OpenCV CMake configuration file
#
#             ** File generated automatically, do not modify **
#
#  Usage from an external project:
#    In your CMakeLists.txt, add these lines:
#
#    FIND_PACKAGE(OpenCV REQUIRED )
#    TARGET_LINK_LIBRARIES(MY_TARGET_NAME ${OpenCV_LIBS})
#
#    This file will define the following variables:
#      - OpenCV_LIBS                 : The list of libraries to links against.
#      - OpenCV_LIB_DIR              : The directory where lib files are. Calling LINK_DIRECTORIES
#                                      with this path is NOT needed.
#      - OpenCV_INCLUDE_DIRS         : The OpenCV include directories.
#      - OpenCV_COMPUTE_CAPABILITIES : The version of compute capability
#      - OpenCV_VERSION              : The version of this OpenCV build. Example: "2.3.1"
#      - OpenCV_VERSION_MAJOR        : Major version part of OpenCV_VERSION. Example: "2"
#      - OpenCV_VERSION_MINOR        : Minor version part of OpenCV_VERSION. Example: "3"
#      - OpenCV_VERSION_PATCH        : Patch version part of OpenCV_VERSION. Example: "1"
#
#    Advanced variables:
#      - OpenCV_SHARED
#      - OpenCV_CONFIG_PATH
#      - OpenCV_INSTALL_PATH
#      - OpenCV_LIB_COMPONENTS
#      - OpenCV_EXTRA_COMPONENTS
#      - OpenCV_USE_MANGLED_PATHS
#      - OpenCV_HAVE_ANDROID_CAMERA
#
# =================================================================================================

# ======================================================
# Version Compute Capability from which library OpenCV
# has been compiled is remembered
# ======================================================
SET(OpenCV_COMPUTE_CAPABILITIES )

# Some additional settings are required if OpenCV is built as static libs
set(OpenCV_SHARED ON)

# Enables mangled install paths, that help with side by side installs
set(OpenCV_USE_MANGLED_PATHS OFF)

# Extract the directory where *this* file has been installed (determined at cmake run-time)
get_filename_component(OpenCV_CONFIG_PATH "${CMAKE_CURRENT_LIST_FILE}" PATH)

# Get the absolute path with no ../.. relative marks, to eliminate implicit linker warnings
get_filename_component(OpenCV_INSTALL_PATH "${OpenCV_CONFIG_PATH}/../.." REALPATH)

# Presence of Android native camera support
set (OpenCV_HAVE_ANDROID_CAMERA )

# ======================================================
# Include directories to add to the user project:
# ======================================================

# Provide the include directories to the caller
SET(OpenCV_INCLUDE_DIRS "${OpenCV_INSTALL_PATH}/include/opencv;${OpenCV_INSTALL_PATH}/include")
INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIRS})

# ======================================================
# Link directories to add to the user project:
# ======================================================

# Provide the libs directory anyway, it may be needed in some cases.
SET(OpenCV_LIB_DIR "${OpenCV_INSTALL_PATH}/lib")
LINK_DIRECTORIES(${OpenCV_LIB_DIR})

# ====================================================================
# Link libraries: e.g.   libopencv_core.so, opencv_imgproc220d.lib, etc...
# ====================================================================
SET(OpenCV_LIB_COMPONENTS opencv_contrib opencv_legacy opencv_objdetect opencv_calib3d opencv_features2d opencv_video opencv_highgui opencv_ml opencv_imgproc opencv_flann opencv_core )
#libraries order is very important because linker from Android NDK is one-pass linker
if(NOT ANDROID)
    LIST(INSERT OpenCV_LIB_COMPONENTS 0 opencv_gpu)
ELSEIF(NOT OpenCV_SHARED AND OpenCV_HAVE_ANDROID_CAMERA)
    LIST(APPEND OpenCV_LIB_COMPONENTS opencv_androidcamera)
endif()

if(OpenCV_USE_MANGLED_PATHS)
      #be explicit about the library names.
      set(OpenCV_LIB_COMPONENTS_ )
      foreach( CVLib ${OpenCV_LIB_COMPONENTS})
        list(APPEND OpenCV_LIB_COMPONENTS_ ${OpenCV_LIB_DIR}/lib${CVLib}.so.2.3.1 )
      endforeach()
      set(OpenCV_LIB_COMPONENTS ${OpenCV_LIB_COMPONENTS_})
endif()

SET(OpenCV_LIBS "")
if(WIN32)
  foreach(__CVLIB ${OpenCV_LIB_COMPONENTS})
      # CMake>=2.6 supports the notation "debug XXd optimized XX"
      if (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} VERSION_GREATER 2.4)
          # Modern CMake:
          SET(OpenCV_LIBS ${OpenCV_LIBS} debug ${__CVLIB} optimized ${__CVLIB})
      else()
          # Old CMake:
          SET(OpenCV_LIBS ${OpenCV_LIBS} ${__CVLIB})
      endif()
  endforeach()
else()
  foreach(__CVLIB ${OpenCV_LIB_COMPONENTS})
    SET(OpenCV_LIBS ${OpenCV_LIBS} ${__CVLIB})
  endforeach()
endif()

# ==============================================================
#  Extra include directories, needed by OpenCV 2 new structure
# ==============================================================
if(NOT "" STREQUAL  "")
    foreach(__CVLIB ${OpenCV_LIB_COMPONENTS})
        # We only need the "core",... part here: "opencv_core" -> "core"
        STRING(REGEX REPLACE "opencv_(.*)" "\\1" __MODNAME ${__CVLIB})
        INCLUDE_DIRECTORIES("/modules/${__MODNAME}/include")
    endforeach()
endif()

# For OpenCV built as static libs, we need the user to link against
#  many more dependencies:
IF (NOT OpenCV_SHARED)
    # Under static libs, the user of OpenCV needs access to the 3rdparty libs as well:
    LINK_DIRECTORIES("${OpenCV_INSTALL_PATH}/share/OpenCV/3rdparty/lib")

    set(OpenCV_LIBS dl;m;pthread;rt  gtk-x11-2.0;gdk-x11-2.0;atk-1.0;gio-2.0;pangoft2-1.0;pangocairo-1.0;gdk_pixbuf-2.0;cairo;pango-1.0;freetype;fontconfig;gobject-2.0;glib-2.0;gthread-2.0;rt;glib-2.0;avcodec;avformat;avutil;swscale;dc1394;v4l1 ${OpenCV_LIBS})
    set(OpenCV_EXTRA_COMPONENTS /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/x86_64-linux-gnu/libpng.so;/usr/lib/x86_64-linux-gnu/libz.so /usr/lib/x86_64-linux-gnu/libtiff.so /usr/lib/x86_64-linux-gnu/libjasper.so;/usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib/x86_64-linux-gnu/libz.so)

    if (WIN32 AND ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} VERSION_GREATER 2.4)
        # Modern CMake:
        foreach(__EXTRA_LIB ${OpenCV_EXTRA_COMPONENTS})
            set(OpenCV_LIBS ${OpenCV_LIBS}
                debug ${__EXTRA_LIB}
                optimized ${__EXTRA_LIB})
        endforeach()
    else()
        # Old CMake:
        set(OpenCV_LIBS ${OpenCV_LIBS} ${OpenCV_EXTRA_COMPONENTS})
    endif()
    
    if (APPLE)
        set(OpenCV_LIBS ${OpenCV_LIBS} "-lbz2" "-framework Cocoa" "-framework QuartzCore" "-framework QTKit")
    endif()
ENDIF()

# ======================================================
#  Android camera helper macro
# ======================================================
IF (OpenCV_HAVE_ANDROID_CAMERA)
  macro( COPY_NATIVE_CAMERA_LIBS target )
    get_target_property(target_location ${target} LOCATION)
    get_filename_component(target_location "${target_location}" PATH)
    file(GLOB camera_wrappers "${OpenCV_LIB_DIR}/libnative_camera_r*.so")
    foreach(wrapper ${camera_wrappers})
      ADD_CUSTOM_COMMAND(
        TARGET ${target}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${wrapper}" "${target_location}"
      )
    endforeach()
  endmacro()
ENDIF()

# ======================================================
#  Version variables:
# ======================================================
SET(OpenCV_VERSION 2.3.1)
SET(OpenCV_VERSION_MAJOR  2)
SET(OpenCV_VERSION_MINOR  3)
SET(OpenCV_VERSION_PATCH  1)
