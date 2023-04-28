#!/bin/bash

# Pull the Ubuntu 22.04 image
docker pull ubuntu:22.04

# Run the container in detached mode and print the container ID
CONTAINER_ID=$(docker run -t -d -v $(pwd):/cwd ubuntu:22.04)

# Connect a shell to the running container
docker exec -it $CONTAINER_ID /bin/bash

# Remove the container when the shell session is exited
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

# conda env export | grep -v "^prefix: " > environment.yml