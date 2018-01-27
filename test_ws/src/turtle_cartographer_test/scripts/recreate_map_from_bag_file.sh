#!/bin/bash

MAP_FILE_NAME=/home/chibike/my_demo_map
SLEEP_TIME=3
MAP_UPDATE_INTERVAL=300

# ROS Parameters
ANGULAR_UPDATE=0.1 # How far the robot has to rotate before a new scan is considered for inclusion in the map
LINEAR_UPDATE=0.1 # How far the robot has to move before a new scan is considered for inclusion in the map
LSKIP=10 # How many beams to skip when processing each LaserScan message

# The extent of the map
XMAX=50
XMIN=-50
YMAX=50
YMIN=-50

echo "Enter bag name (e.g data.bag)?"
read BAG_FILE_NAME

echo "Enter map name (e.g my_map)?"
read MAP_FILE_NAME

echo "Running roscore"
gnome-terminal --command="roscore"
sleep $SLEEP_TIME

echo "Using timestamps defined in bag file"
rosparam set /use_sim_time true
sleep $SLEEP_TIME

echo "Setting ros parameters ...."
rosparam set /slam_gmapping/angularUpdate $ANGULAR_UPDATE
rosparam set /slam_gmapping/linearUpdate $LINEAR_UPDATE
rosparam set /slam_gmapping/lskip $LSKIP
rosparam set /slam_gmapping/xmax $XMAX
rosparam set /slam_gmapping/xmin $XMIN
rosparam set /slam_gmapping/ymax $YMAX
rosparam set /slam_gmapping/ymin $YMIN

echo "Running turtlebot bringup"
gnome-terminal --command="roslaunch turtlebot_bringup minimal.launch"
sleep $SLEEP_TIME

echo "Running gmapping"
#gnome-terminal --command="rosrun gmapping slam_gmapping"
gnome-terminal --command="roslaunch turtlebot_navigation gmapping_demo.launch"
sleep $SLEEP_TIME

echo "Starting bag file"
gnome-terminal --command="rosbag play --clock $BAG_FILE_NAME /laser_scan:=/scan"

echo "Running rviz"
gnome-terminal --command="roslaunch turtlebot_rviz_launchers view_navigation.launch"

while :
do
    sleep $MAP_UPDATE_INTERVAL
    rosrun map_server map_saver -f $MAP_FILE_NAME
done
