#!/usr/bin/env bash

set -eu

apt-get update
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
	gedit \
	emacs \
	pinta \
	vim \
	vim-tiny \
	tmux
