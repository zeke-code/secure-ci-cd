#!/bin/bash

command_exists() {
    command -v "$1" &> /dev/null
}

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command_exists docker compose; then
    echo "Docker Compose is not installed. Please install Docker Compose."
    exit 1
fi

# Checks if a Docker image has already been built.
# If not, build it.
build_image_if_needed() {
    local image_name="$1"
    local dockerfile_dir="$2"
    
    if [[ "$(docker images -q $image_name 2> /dev/null)" == "" ]]; then
        echo "Building custom image: $image_name..."
        docker build -t "$image_name" "$dockerfile_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to build $image_name image. Exiting."
            exit 1
        fi
    else
        echo "Image $image_name already exists. Skipping build."
    fi
}

build_image_if_needed jenkins-server ./jenkins

docker compose up
if [ $? -ne 0 ]; then
    echo "Failed to start Docker Compose. Exiting."
    exit 1
fi
