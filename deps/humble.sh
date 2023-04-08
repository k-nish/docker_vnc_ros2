#/usr/bin/env bash

export ROS_DISTRO=humble
export LANG=en_US.UTF-8
export INSTALL_ROS_KEY=C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt-get update && sudo apt-get install -y --no-install-recommends --allow-unauthenticated \
     locales \
     curl \
     gnupg2 \
     lsb-release \
     libflann-dev \
     libpcl-dev \
     libboost-all-dev \
     libeigen-stl-containers-dev \
     libqhull-dev \
     librosconsole-bridge-dev \
     libccd-dev \
     python3-pykdl \
     doxygen \
    && sudo apt-get autoclean \
    && sudo apt-get autoremove \
    && sudo locale-gen en_US en_US.UTF-8 \
    && sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null \
    && sudo apt update \
    && sudo apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-desktop \
     ros-${ROS_DISTRO}-cv-bridge \
     ros-${ROS_DISTRO}-ament-* \
     python3-colcon-common-extensions \
     python3-colcon-mixin \
     python3-rosdep \
     python3-vcstool \
    && sudo apt-get install -y python3-colcon-common-extensions \
         python3-vcstool \
    && rosdep init || true && rosdep update --rosdistro ${ROS_DISTRO}

echo "\033[33mInstalled ROS ${ROS_DISTRO} \033[0m"
