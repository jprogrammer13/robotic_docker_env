FROM nvidia/cuda:11.6.0-cudnn8-runtime-ubuntu20.04

RUN apt-get update
RUN apt-get install sudo 
RUN sudo apt install -qqy lsb-release gnupg2 curl -y

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG DEBIAN_FRONTEND=noninteractive

# install ros
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
RUN sudo apt-get update
RUN apt-get install ros-noetic-desktop-full -y
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN apt-get install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
RUN sudo rosdep init
RUN rosdep update

# install ros packages
RUN apt-get install ros-noetic-urdfdom-py \
            ros-noetic-urdfdom-py \
            ros-noetic-joint-state-publisher \
            ros-noetic-joint-state-publisher-gui \
            ros-noetic-joint-state-controller \
            ros-noetic-gazebo-msgs \
            ros-noetic-control-toolbox \
            ros-noetic-gazebo-ros \
            ros-noetic-controller-manager \ 
            ros-noetic-srdfdom \
            ros-noetic-joint-trajectory-controller -y

# install realsense camera support
RUN apt-get install ros-noetic-openni2-launch \
                    ros-noetic-openni2-camera \
                    ros-noetic-realsense2-description -y

# install grasping support
RUN apt-get install ros-noetic-eigen-conversions  \
                    ros-noetic-object-recognition-msgs \
                    ros-noetic-roslint -y

# install pinocchio
RUN sudo sh -c "echo 'deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub focal robotpkg' >> /etc/apt/sources.list.d/robotpkg.list"
RUN sudo sh -c "echo 'deb [arch=amd64] http://robotpkg.openrobots.org/wip/packages/debian/pub focal robotpkg' >> /etc/apt/sources.list.d/robotpkg.list"

RUN curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | sudo apt-key add -
RUN sudo apt-get update

RUN apt-get install robotpkg-py38-eigenpy \
                    robotpkg-py38-pinocchio \
                    robotpkg-py38-quadprog -y

#install python lib
RUN apt-get install python3-scipy \
                    python3-matplotlib \
                    python3-termcolor \
                    python3-pip -y

RUN pip3 install cvxpy==1.2.0
RUN pip3 install tesnroboard
RUN pip3 install joblib
RUN pip3 install torch