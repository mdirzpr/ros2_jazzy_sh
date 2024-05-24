#!bin/bash

set -e

echo 'Choose version:'
echo '1 - Desktop (Recommended): ROS, RViz, demos, tutorials.'
echo '2 - Base (Bare Bones): No GUI tools.'
read VERSION
if [ "$VERSION" != "1" ] && [ "$VERSION" != "2" ]; then
  echo 'Only 1 or 2 are allowed, not '$VERSION
  exit 1
fi

locale  # check for UTF-8

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update && sudo apt install ros-dev-tools

sudo apt update
sudo apt upgrade


if [ "$VERSION" = "1" ]; then
  sudo apt install ros-jazzy-desktop -y
else
  sudo apt install ros-jazzy-ros-base -y
fi

if [ "$VERSION" = "2" ]; then
  # cpp demo nodes
  sudo apt install ros-jazzy-demo-nodes-cpp
fi

sudo apt install python3-colcon-common-extensions -y

echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
echo "source /usr/share/colcon_cd/function/colcon_cd-argcomplete.bash" >> ~/.bashrc
source .bashrc

# Examples for testing ROS2
# ros2 run demo_nodes_cpp talker
# ros2 run demo_nodes_cpp listener
