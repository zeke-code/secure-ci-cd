#!/bin/bash

# Wait for SonarQube to start
sleep 80

# Create SonarQube token
TOKEN=$(curl -u admin:admin -X POST 'http://sonarqube:9000/api/user_tokens/generate' -d "name=jenkins-token" | jq -r .token)

echo "Generated token: $TOKEN"

# Save token to a file (or securely store it in a Docker secret)
echo $TOKEN > /var/jenkins_home/sonarqube_token.env

# Export the token as an environment variable
export SONARQUBE_TOKEN=$TOKEN

# Start Jenkins
exec /usr/local/bin/jenkins.sh
