#!/bin/bash

MAP_FILE_NAME=../test_maps/gmapping_map
SLEEP_TIME=3
MAP_UPDATE_INTERVAL=20

echo "Running roscore"
gnome-terminal --command="roscore"
sleep $SLEEP_TIME

echo "Using timestamps defined in bag file"
rosparam set /use_sim_time true
sleep $SLEEP_TIME

echo "Launching gmapping"
gnome-terminal --command="roslaunch turtle_cartographer_test create_2d_map_from_bag_gmapping.launch"

while :
do
	sleep $MAP_UPDATE_INTERVAL
    rosrun map_server map_saver -f $MAP_FILE_NAME
done
