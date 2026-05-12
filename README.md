# RSS Spot Stack ROS (Simulation Environment)

> **⚠️ IMPORTANT:** This workspace is purely for **simulation**. 
> - ❌ **Do NOT** connect to a physical robot.
> - ❌ **Do NOT** set a `robot_ip`.
> - ❌ **Do NOT** install hardware drivers.

## 📋 Table of Contents
- [RSS Spot Stack ROS (Simulation Environment)](#rss-spot-stack-ros-simulation-environment)
  - [📋 Table of Contents](#-table-of-contents)
  - [🎯 Purpose of This Workspace](#-purpose-of-this-workspace)
  - [✅ Prerequisites](#-prerequisites)
  - [📦 Installation \& Build](#-installation--build)
    - [1. Clone the Repository](#1-clone-the-repository)
    - [2. Build the Docker Image](#2-build-the-docker-image)
  - [🚀 Running the Simulation](#-running-the-simulation)
  - [🧪 Testing Navigation](#-testing-navigation)
  - [🛠 Useful ROS 2 Commands](#-useful-ros-2-commands)
  - [🧰 Troubleshooting](#-troubleshooting)

---

## 🎯 Purpose of This Workspace

This repository provides a **Dockerized ROS 2 environment** for working with the Boston Dynamics Spot mobile base and arm **entirely in simulation**.  

It is specifically tailored for the **RSS Project**, where students must:
1. Read sensor data from external microcontrollers (e.g., ESP8266 / MPU6050).
2. Send this data to ROS 2 over Wi-Fi.
3. Map sensor values to robot motions.
4. Control a **simulated Spot robot** in real-time.

**Key Features Included:**
- **URDF visualization** for accurate robot representation.
- **`ros2_control` with fake hardware** (primary mode).
- **MoveIt 2** for advanced motion planning and kinematics.
- **Gazebo / Ignition** for realistic 3D physics simulation.

*(No real robot, IP address, or hardware connection is needed!)*

---

## ✅ Prerequisites

Since this is a containerized environment, ensure you have the following installed on your host machine:
* [Docker](https://docs.docker.com/get-docker/)
* [Git](https://git-scm.com/downloads)

---

## 📦 Installation & Build

This project relies on **Git submodules** to pull in the necessary Spot packages. 

### 1. Clone the Repository
Clone the repo and initialize the submodules automatically:
```bash
git clone --recurse-submodules <repository-url>
cd <repository-folder>

```

*(If you already cloned the repo normally, run: `git submodule update --init --recursive`)*

### 2. Build the Docker Image

Inside the root of the repository, build the container environment:

```bash
bash build.sh

```

*Note: This process may take a few minutes to download and configure the ROS 2 environment.*

---

## 🚀 Running the Simulation

You will need to open **three separate terminals** to launch the full simulation stack. Make sure you are in the repository root for each.

**Terminal 1: Configure Communication Layer**

```bash
bash docker_run/setup_zenoh.sh

```

**Terminal 2: Launch Gazebo (3D Simulation)**

```bash
bash docker_run/docker_run_gazebo.sh

```

**Terminal 3: Launch MoveIt (Motion Planning)**

```bash
bash docker_run/docker_run_moveit.sh

```

---

## 🧪 Testing Navigation

You can test the base navigation by publishing a velocity command to the robot.

**Note:** If you do not have ROS 2 installed on your host machine, you must run these commands *inside* the running Docker container.

```bash
# 1. Source the ROS 2 and workspace environments
source /opt/ros/humble/setup.bash
source /colcon_ws/install/setup.bash

# 2. Set the Zenoh middleware
export RMW_IMPLEMENTATION=rmw_zenoh_cpp

# 3. Publish a velocity command to move Spot forward
ros2 topic pub /cmd_vel geometry_msgs/msg/Twist \
  "{linear: {x: 0.3}, angular: {z: 0.0}}" --once

```

---

## 🛠 Useful ROS 2 Commands

Once your simulation is running, you can use these commands in a sourced terminal to inspect the system:

```bash
# List all active ROS 2 topics
ros2 topic list

# Monitor the joint states of the robot in real-time
ros2 topic echo /joint_states

# Verify that the fake hardware controllers are active
ros2 control list_controllers

# Open the visualizer
rviz2

```

---

## 🧰 Troubleshooting

**RViz does not start properly or crashes**

Try launching RViz with the Qt5 fix disabled:

```bash
rviz2 --disable-qt5-fix

```

**Custom topics or packages are missing**

Ensure you have sourced your workspace correctly in your current terminal:

```bash
source /colcon_ws/install/setup.bash

```

**Nodes aren't communicating (DDS / Discovery issues)**

Ensure the proper middleware and domain IDs are set in every terminal you open:

```bash
export RMW_IMPLEMENTATION=rmw_zenoh_cpp
export ROS_DOMAIN_ID=22

```

**How do I update submodules if the upstream branch changes?**

```bash
git submodule update --remote --merge

```
