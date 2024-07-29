#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker first."
    exit
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null
then
    echo "Docker Compose is not installed. Please install Docker Compose."
    exit
fi

# Build the custom images
echo "Building custom Jenkins image..."
docker build -t jenkins-server ./jenkins
if [ $? -ne 0 ]; then
    echo "Failed to build Jenkins image. Exiting."
    exit 1
fi

# Start the application
docker compose up --build

echo "Application is running. You can access it at http://localhost:8080"
