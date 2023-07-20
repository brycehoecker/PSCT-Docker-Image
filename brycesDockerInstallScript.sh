#!/bin/bash

# Set Docker image name
imagename="bryces_PSCT_docker_image"

# prompt for github username
#echo -n "Enter GitHub username: "
#read username

# prompt for github password
#echo -n "Enter GitHub password: "
#read -s password

# prompt for image name
#echo -n "Enter Docker image name: "
#read imagename

# Build the Docker image and pass the gitlab username and password
#docker build --build-arg git_username=$username --build-arg git_password=$password -t $imagename .

# Build the Docker image
docker build -t $imagename .
echo "Docker image $imagename built successfully"

echo "Now running the $imagename Docker container interactively"
# Run the Docker container interactively
docker run -it $imagename




