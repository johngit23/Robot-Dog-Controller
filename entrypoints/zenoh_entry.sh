#!/bin/bash

source /opt/ros/humble/setup.bash
source /colcon_ws/install/setup.bash

(return 0 2>/dev/null) || { echo "Please 'source' this file:  source $BASH_SOURCE"; exit 1; }
export ROS_DOMAIN_ID=22
export ZENOH_ROUTER_CONFIG_URI=/colcon_ws/src/rmw_zenoh/router_config.json5

ros2 run rmw_zenoh_cpp rmw_zenohd
