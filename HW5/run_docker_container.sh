#!/bin/bash

# image from Docker Hub 
IMAGE_NAME="alasar/ustas-nginx-hw5:latest"

# download Docker-image from Docker Hub
echo "Pulling Docker image: $IMAGE_NAME"
docker pull $IMAGE_NAME

# check download
if [ $? -eq 0 ]; then
    echo "Docker image pulled successfully."
else
    echo "Failed to pull Docker image."
    exit 1
fi

# run container with port 80
echo "Running Docker container on port 80..."
docker run -d -p 80:80 $IMAGE_NAME

# check container
if [ $? -eq 0 ]; then
    echo "Docker container is running on port 80."
else
    echo "Failed to run Docker container."
    exit 1
fi
