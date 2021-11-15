cmake_minimum_required(VERSION 3.3)

# Find ros dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(ov_core REQUIRED)

# Describe ROS project
option(ENABLE_ROS "Enable or disable building with ROS (if it is found)" ON)
if (NOT ENABLE_ROS)
    message(FATAL_ERROR "Build with ROS1.cmake if you don't have ROS.")
endif ()

# Include our header files
include_directories(
        src
        ${EIGEN3_INCLUDE_DIR}
        ${Boost_INCLUDE_DIRS}
        ${PYTHON_INCLUDE_DIRS}
        /usr/local/lib/python2.7/dist-packages/numpy/core/include
        /usr/local/lib/python2.7/site-packages/numpy/core/include
)

# Set link libraries used by all binaries
list(APPEND thirdparty_libraries
        ${Boost_LIBRARIES}
        ${PYTHON_LIBRARIES}
)

##################################################
# Make the shared library
##################################################

add_library(ov_init_lib SHARED
        src/dummy.cpp
        src/init/InertialInitializer.cpp
        src/static/StaticInitializer.cpp
)
ament_target_dependencies(ov_init_lib rclcpp ov_core)
target_link_libraries(ov_init_lib ${thirdparty_libraries})
target_include_directories(ov_init_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/)
install(TARGETS ov_init_lib
        LIBRARY         DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME         DESTINATION ${CMAKE_INSTALL_BINDIR}
        PUBLIC_HEADER   DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
ament_export_include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/)
ament_export_libraries(ov_init_lib)


# finally define this as the package
ament_package()
