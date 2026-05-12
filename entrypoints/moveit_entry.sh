#!/bin/bash

export RMW_IMPLEMENTATION=rmw_zenoh_cpp
source /colcon_ws/install/setup.bash
source /opt/ros/humble/setup.bash

ros2 launch spot_moveit_config spot_moveit.launch.py
