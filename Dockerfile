# Use official ROS 2 Humble base image
FROM ros:humble-ros-base

# RMW ZENOH experimental flag
ARG EXPERIMENTAL_ZENOH_RMW="TRUE"

# Set noninteractive mode for APT
ENV DEBIAN_FRONTEND=noninteractive

# Env setup
ENV SHELL=/bin/bash
SHELL ["/bin/bash", "-c"]

# Install dependencies
# (curl, git, and nano were merged here. Locales and ROS 2 sources are already set in the base image)
RUN apt-get update -q && \
    apt-get install -yq --no-install-recommends --fix-missing \
    curl \
    git \
    wget \ 
    software-properties-common \ 
    python3-pip \
    python-is-python3 \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    libpython3-dev \
    python3-tk \
    ros-dev-tools \
    qtbase5-dev \
    qttools5-dev \
    libqt5svg5-dev \
    ros-humble-draco-point-cloud-transport \
    nano \
    # check if Zenoh should be installed
    $(if [ "$EXPERIMENTAL_ZENOH_RMW" = "TRUE" ]; then echo "ros-humble-rmw-zenoh-cpp"; fi) \
    && rm -rf /var/lib/apt/lists/*

# Set up workspace
WORKDIR /colcon_ws/src

# Initialize rosdep (rosdep init is usually already run in the official image)
RUN rosdep init || true \
    && rosdep update

# Clone driver code
RUN git clone https://github.com/bdaiinstitute/spot_ros2.git .
RUN git submodule update --init --recursive

# Run install script and pass in the architecture
RUN ARCH=$(dpkg --print-architecture) && echo "Building driver with $ARCH" && /colcon_ws/src/install_spot_ros2.sh --$ARCH

COPY colcon_ws/src/ /colcon_ws/src/

# Build packages with Colcon
WORKDIR /colcon_ws/

RUN touch src/spot_description/spot_description/COLCON_IGNORE

RUN apt-get update && \
    . /opt/ros/humble/setup.sh && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --symlink-install


RUN apt update && apt install -y --no-install-recommends \
    ros-humble-moveit \
    ros-humble-moveit-visual-tools \
    ros-humble-moveit-ros-visualization \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoints/gazebo_entry.sh /gazebo_entry.sh
RUN chmod +x /gazebo_entry.sh
COPY entrypoints/moveit_entry.sh /moveit_entry.sh
RUN chmod +x /moveit_entry.sh
COPY entrypoints/zenoh_entry.sh /zenoh_entry.sh
RUN chmod +x /zenoh_entry.sh

WORKDIR /colcon_ws/

# Source the workspace
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /colcon_ws/install/setup.bash" >> ~/.bashrc
RUN echo "export RMW_IMPLEMENTATION=rmw_zenoh_cpp" >> ~/.bashrc
RUN echo "export ROS_DOMAIN_ID=22" >> ~/.bashrc

RUN echo 'export BOSDYN_CLIENT_USERNAME="user"' >> ~/.bashrc
RUN echo 'export BOSDYN_CLIENT_PASSWORD="7imkn5gffaz9"' >> ~/.bashrc
RUN echo 'export SPOT_IP=192.168.50.3' >> ~/.bashrc
RUN echo "export SPOT_VELODYNE=1" >> ~/.bashrc && \
    echo "export SPOT_LIDAR_MOUNT=1" >> ~/.bashrc && \
    echo "export SPOT_VELODYNE_XYZ='-0.33 0 0.12'" >> ~/.bashrc && \
    echo "export SPOT_PACK=1" >> ~/.bashrc
