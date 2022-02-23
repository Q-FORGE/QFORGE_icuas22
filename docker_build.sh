#!/bin/bash

echo "Building icuas22_competition Docker image"

distro="focal"
build_args=""
for (( i=1; i<=$#; i++));
do
  param="${!i}"
  echo $param

  if [ "$param" == "--bionic" ]; then
    distro="bionic"
  fi

  if [ "$param" == "--focal" ]; then
    distro="focal"
  fi

  if [ "$param" == "--focal-nogpu" ]; then
    distro="focal-nogpu"
  fi

  if [ "$param" == "--build-args" ]; then
    j=$((i+1))
    build_args="${!j}"
  fi

done

echo "Building for $distro with additional docker arguments $build_args."


# Check if UAV_ros repo exists

if [ "$(docker images -q lmark/uav_ros_simulation:focal 2> /dev/null)" == "" -a "$(docker images -q icuas22_competition:focal 2> /dev/null)" == "" ];
echo "UAV ROS and icuas_2022 images detected"
then
  docker build \
    $build_args \
    --cache-from lmark1/uav_ros_simulation\
    --cache-from icuas22_competition\
    -f Dockerfile.$distro \
    -t icuas22_competition:$distro .
elif [[ "$(docker images -q lmark/uav_ros_simulation:focal 2> /dev/null)" == "" ]]; then
echo "UAV ROS image detected"
  docker build \
    $build_args \
    --cache-from lmark1/uav_ros_simulation\
    -f Dockerfile.$distro \
    -t icuas22_competition:$distro .
else
  docker build \
    $build_args \
    -f Dockerfile.$distro \
    -t icuas22_competition:$distro .
fi

