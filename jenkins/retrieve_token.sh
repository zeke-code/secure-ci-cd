#!/bin/bash

# Function to wait for SonarQube to be fully operational
function wait_for_sonarqube() {
  sleep 80
}

# Wait for SonarQube
wait_for_sonarqube

# Function to wait for Jenkins to be fully operational
function wait_for_jenkins() {
  echo "Waiting for Jenkins to be fully operational..."
  until [ "$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080)" == "200" ]; do
    echo "Jenkins is not yet ready. Waiting..."
    sleep 10
  done
  echo "Jenkins is operational."
}

# Start Jenkins in the background
/usr/local/bin/jenkins.sh &

# Wait for Jenkins to be fully operational
wait_for_jenkins

# Fetch the SonarQube authentication token
response=$(curl -u admin:admin -X POST 'http://sonarqube:9000/api/user_tokens/generate' -d 'name=jenkins_token')
token=$(echo $response | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
echo "Generated Token: $token"
echo "SONARQUBE_TOKEN=${token}" > /var/jenkins_home/sonarqube_token.env

# Keep the container running
tail -f /dev/null
