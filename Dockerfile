FROM nvidia/cuda:11.1-base-ubuntu20.04

MAINTAINER krishneel@krishneel

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_PYTHON_VERSION 3
ENV ROS_DISTRO foxy

RUN apt-get update && \
	apt-get install -y --no-install-recommends --allow-unauthenticated \
	bash-completion \
	cmake \
	dirmngr \
	git \
	gnupg2 \
	libssl-dev \
	lsb-release \
	python3-pip \
	wget \
	curl \
        supervisor \
	openssh-server \
	pwgen \
	sudo \
        net-tools \
	lxde \
	x11vnc \
	xvfb \
	gtk2-engines-murrine \
	ttf-ubuntu-font-family \
        nginx \
	build-essential \
        mesa-utils libgl1-mesa-dri \
	gnome-themes-standard \
	gtk2-engines-pixbuf \
	gtk2-engines-murrine \
	arc-theme \
	dbus-x11 \
	x11-utils \
	terminator \
	tini \
	firefox \
	# gedit \
	emacs \
	pinta \
	vim \
	vim-tiny \
	&& apt-get autoclean \
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

################################################################################
# install ROS foxy (from https://github.com/osrf/docker_images/blob/master/ros/foxy/ubuntu/focal/ros-core/Dockerfile)
################################################################################

RUN apt-get update && \
	apt-get install -y --no-install-recommends --allow-unauthenticated \
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
	&& apt-get autoremove \
	&& rm -rf /var/lib/apt/lists/*

# setup timezone
RUN rm /etc/localtime
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

# label ros2 packages
LABEL org.osrfoundation.ros-foxy-ros-core.sha256=2a68a22ce423555d65bcb0a40c5217a892aa1461ed9a303cc1c327faa34c6b75

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-desktop \
    && rm -rf /var/lib/apt/lists/*

# =================================

# RUN wget https://github.com/OctoMap/octomap/archive/v1.8.1.tar.gz \
# 	&& tar -xzvf v1.8.1.tar.gz \
# 	&& cd octomap-1.8.1 && mkdir build && cd build \
# 	&& cmake .. && make -j${nproc} && make install

# RUN git clone https://github.com/ompl/ompl.git /ompl
# RUN mkdir -p /ompl/build && cd /ompl/build && cmake .. && make -j${nproc}
# RUN cd /ompl/build && make install -j${nproc} && make clean

# RUN git clone https://github.com/flexible-collision-library/fcl.git /fcl
# RUN mkdir -p /fcl/build && cd /fcl/build && cmake .. && make -j${nproc}
# RUN cd /fcl/build && make install -j${nproc}

RUN ln -s /usr/bin/python3 /usr/local/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

ADD image /
RUN pip3 install setuptools wheel && pip3 install -r /usr/lib/web/requirements.txt
RUN pip3 install numpy

RUN cp /usr/share/applications/terminator.desktop /root/Desktop
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc

EXPOSE 80
WORKDIR /home
ENV HOME /home
ENV SHELL /bin/bash
ENV COLCON_HOME $HOME/.colcon
ENV HOSTNAME ros2

ENV RCUTILS_COLORIZED_OUTPUT 1
ENV RCUTILS_LOGGING_BUFFERED_STREAM 1

ENTRYPOINT ["/startup.sh"]
