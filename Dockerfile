FROM ros:humble-ros-base

# Install ROS2 packages
RUN apt update && apt install -y \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-tf2-geometry-msgs\
    ros-${ROS_DISTRO}-image-transport \
    ros-$ROS_DISTRO-vision-opencv \
    ros-${ROS_DISTRO}-mavros* \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    libyaml-cpp-dev \
    libc++abi-11-dev \
    libstdc++-11-dev \
    libc++-11-dev \
    vulkan-tools \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/libstdc++.so


COPY . /Colosseum

RUN /Colosseum/setup.sh
RUN /Colosseum/build.sh

WORKDIR /Colosseum/ros2/
COPY ros2/ .
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

ENTRYPOINT [ "../entrypoint.sh" ]
CMD [ "ros2", "launch", "airsim_ros_pkgs", "airsim_node.launch.py" ]