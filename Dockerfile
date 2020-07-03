# FROM ubuntu:18.04
FROM osrf/ros2:nightly

MAINTAINER krishneel@krishneel

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_PYTHON_VERSION 3

# built-in packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        firefox \
        nginx \
	build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils \
	terminator \
	gedit \
	emacs \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# =================================

RUN apt-get update && apt-get install -y \
	libboost-all-dev \
	libeigen-stl-containers-dev \
	libqhull-dev \
	librosconsole-bridge-dev \
	libccd-dev \
	python3-pykdl\
	cmake \
	doxygen \
	&& pip3 install ipython cython \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/OctoMap/octomap/archive/v1.8.1.tar.gz \
	&& tar -xzvf v1.8.1.tar.gz \
	&& cd octomap-1.8.1 && mkdir build && cd build \
	&& cmake .. && make -j${nproc} && make install

RUN git clone https://github.com/ompl/ompl.git /ompl
RUN mkdir -p /ompl/build && cd /ompl/build && cmake .. && make -j${nproc}
RUN cd /ompl/build && make install -j${nproc} && make clean

RUN git clone https://github.com/flexible-collision-library/fcl.git /fcl
RUN mkdir -p /fcl/build && cd /fcl/build && cmake .. && make -j${nproc}
RUN cd /fcl/build && make install -j${nproc}

RUN apt-get update && apt-get install -y libflann1.9 libflann-dev
RUN git clone https://github.com/PointCloudLibrary/pcl.git /pcl
RUN cd /pcl && mkdir build && cd build && cmake .. && make -j${nproc} \
	&& make install -j${nproc} && make clean && rm -rf *

# =================================

RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros-focal.list && \
	apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
	apt-get update && apt-get install ros-noetic-ros-base -y && \
	rm -rf /var/lib/apt/lists/*

# RUN apt-get update && \
# 	apt-get install ros-foxy-diagnostic-msgs -y &&  \
# 	rm -rf /var/lib/apt/lists/*

# =================================

# tini for subreap
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# temporary just python2 for the web (fix later)
RUN apt-get update && apt-get install -y python-dev python2 && \
	curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py && \
	python2 get-pip.py && \
	rm -rf /var/lib/apt/lists/*

ADD image /
RUN pip2 install setuptools wheel && pip2 install -r /usr/lib/web/requirements.txt
RUN rm -rf /usr/local/bin/pip

RUN cp /usr/share/applications/terminator.desktop /root/Desktop
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc

EXPOSE 80
WORKDIR /home
ENV HOME /home
ENV SHELL /bin/bash
ENV COLCON_HOME $HOME/.colcon

ENTRYPOINT ["/startup.sh"]
