docker-ros2-vnc-desktop
=========================

[![Docker Pulls](https://img.shields.io/docker/pulls/krishneel/vnc-ros2-foxy)](https://hub.docker.com/r/krishneel/vnc-ros2-foxy/)

Docker image to provide HTML5 VNC interface to access ROS2 Foxy on Ubuntu Focal with the LXDE desktop environment.

Quick Start
-------------------------

Run the docker image and open port `6080`

```
docker run -it --rm -p 6080:80 krishneel/vnc-ros2-foxy
```

Browse http://127.0.0.1:6080/

![screenshot](https://github.com/iKrishneel/docker-ubuntu-vnc-desktop/blob/master/assets/ros2-foxy.png)


Connect with VNC Viewer and protect by VNC Password
------------------

Forward VNC service port 5900 to host by

```
docker run -it --rm -p 6080:80 -p 5900:5900 krishneel/vnc-ros2-foxy
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword krishneel/vnc-ros2-foxy
```

A prompt will ask password either in the browser or vnc viewer.


Mount directory
---------------

Mount host directory to docker using

```
docker run -v <your directory>:/mnt/ -it --rm -p 6080:80 krishneel/vnc-ros2-foxy

```


Troubleshooting and FAQ
==================

1. boot2docker connection issue, https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/2
2. Screen resolution is fitted to browser's window size when first connecting to the desktop. If you would like to change resolution, you have to re-create the container


License
==================

See the LICENSE file for details.
