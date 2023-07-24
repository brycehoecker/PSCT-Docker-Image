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

# Create the .ssh Directory
mkdir -p ~/.ssh

# Set the SSH key path
SSH_KEY_PATH="$HOME/.ssh/gitlab_docker"

# Prompt the user for their GitLab email
echo -ne "${YELLOW}Please enter your GitLab email:${NC} "
read GITLAB_EMAIL

# Check if the SSH key already exists
if [ ! -f $SSH_KEY_PATH ]; then
  echo -e "${YELLOW}Generating a new SSH key...${NC}"
  ssh-keygen -t ed25519 -C "$GITLAB_EMAIL" -f $SSH_KEY_PATH -N ""
else
  echo -e "${GREEN}Existing SSH key found, skipping generation.${NC}"
fi

# Print the public key
echo -e "${GREEN}Please add the following public key to your GitLab account:${NC}"
cat "${SSH_KEY_PATH}.pub"

# Prompt user for confirmation
echo -e "${YELLOW}Press enter to continue once you've added the SSH key to your GitLab account...${NC}"
read -p ""

# Load the SSH key
SSH_PRIVATE_KEY=$(cat $SSH_KEY_PATH)

# Build the Docker image
echo -e "${YELLOW}Now building the Docker image $imagename .... ${NC}"
docker build --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" -t $imagename .

# Check if the build process was successful
if [ $? -eq 0 ]
then
    echo -e "${YELLOW}Docker image $imagename has finished attempting to build.${NC}"

    # Run the Docker container interactively
    echo -e "${CYAN}Now running the $imagename Docker container interactively.${NC}"
    docker run -it $imagename
else
    echo -e "${RED}Docker image $imagename failed to build. Fix the issues and try again.${NC}"
fi
