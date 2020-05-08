# FROM ubuntu:18.04
FROM osrf/ros2:nightly

ENV DEBIAN_FRONTEND noninteractive

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
	# python-pip python-dev
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

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_PYTHON_VERSION 3

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
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
