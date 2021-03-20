#/usr/bin/env bash

export ROS_DISTRO=foxy

sudo apt-get update
sudo apt-get install -y --no-install-recommends --allow-unauthenticated \
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
     redis-tools \
     redis-server \
    && apt-get autoclean \
    && apt-get autoremove

sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# setup keys
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
     --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

# install ros2 packages
sudo apt-get update
sudo apt-get install -y --no-install-recommends ros-${ROS_DISTRO}-desktop
