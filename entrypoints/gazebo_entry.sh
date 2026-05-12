#!/bin/bash

export IGN_GAZEBO_RESOURCE_PATH=/colcon_ws/install/spot_empty_world/share:/colcon_ws/install/spot_description/share
export GZ_SIM_RESOURCE_PATH=/colcon_ws/install/spot_empty_world/share:/colcon_ws/install/spot_description/share
export SDF_PATH=/colcon_ws/install/spot_empty_world/share:/colcon_ws/install/spot_description/share
export LD_LIBRARY_PATH=/opt/ros/humble/lib:$LD_LIBRARY_PATH
export IGN_GAZEBO_SYSTEM_PLUGIN_PATH=/opt/ros/humble/lib:$IGN_GAZEBO_SYSTEM_PLUGIN_PATH

export RMW_IMPLEMENTATION=rmw_zenoh_cpp
source /colcon_ws/install/setup.bash
source /opt/ros/humble/setup.bash

ros2 launch spot_empty_world spot_empty_world.launch.py
