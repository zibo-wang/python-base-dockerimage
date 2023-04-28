#!/bin/bash

# Set environment variables
DOCKER_IMAGE_NAME="my-jupyter-lab"
DOCKER_CONTAINER_NAME="my-jupyter-lab-container"
DOCKER_PORT="8888"
DOCKER_ENVIRONMENT_FILE="environment.yml"

# Build the Docker image
docker build -t ${DOCKER_IMAGE_NAME} .

# Run the Docker container
docker run -d -p ${DOCKER_PORT}:${DOCKER_PORT} \
           --name ${DOCKER_CONTAINER_NAME} \
           --env-file ${DOCKER_ENVIRONMENT_FILE} \
           ${DOCKER_IMAGE_NAME}

# Display the Jupyter Lab URL
echo "Jupyter Lab is now running at http://localhost:${DOCKER_PORT}"