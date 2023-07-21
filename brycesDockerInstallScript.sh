#!/bin/bash

# Define ANSI escape codes for colors and resets
BLACK='\033[0;30m'			# echo -e "${BLACK} BLACK_TEXT_TO_PRINT ${NC}"
RED='\033[0;31m'			# echo -e "${RED} RED_TEXT_TO_PRINT ${NC}"
GREEN='\033[0;32m'			# echo -e "${GREEN} GREEN_TEXT_TO_PRINT ${NC}"
YELLOW='\033[0;33m'			# echo -e "${YELLOW} YELLOW_TEXT_TO_PRINT ${NC}"
BLUE='\033[0;34m'			# echo -e "${BLUE} BLUE_TEXT_TO_PRINT ${NC}"
PURPLE='\033[0;35m'			# echo -e "${PURPLE} PURPLE_TEXT_TO_PRINT ${NC}"
CYAN='\033[0;36m'			# echo -e "${CYAN} CYAN_TEXT_TO_PRINT ${NC}"
WHITE='\033[0;37m'			# echo -e "${WHITE} WHITE_TEXT_TO_PRINT ${NC}"
NC='\033[0m' # No Color		# ${NC}

# Set Docker image name
imagename="psct_docker"

# Build the Docker image
echo -e "${YELLOW}Now building the Docker image $imagename .... ${NC}"
docker build -t $imagename .
echo -e "${YELLOW}Docker image $imagename has finished attempting to build.${NC}"

# Run the Docker container interactively
echo -e "${CYAN}Now running the $imagename Docker container interactively.${NC}"
docker run -it $imagename



## prompt for github username
#echo -n "Enter GitHub username: "
#read username
#
## prompt for github password
#echo -n "Enter GitHub password: "
#read -s password
#
## prompt for image name
#echo -n "Enter Docker image name: "
#read imagename
#
## Build the Docker image and pass the gitlab username and password
#docker build --build-arg git_username=$username --build-arg git_password=$password -t $imagename .



