#!/bin/bash

FLAG_FILE="/var/jenkins_home/sonarqube_token_generated.flag"
TOKEN_FILE="/var/jenkins_home/sonarqube_token.env"
WEBHOOK_NAME="jenkins"
WEBHOOK_URL="http://jenkins:8080/sonarqube-webhook"

# Check if the token has already been generated
if [ ! -f "$FLAG_FILE" ]; then

  # Wait for SonarQube container to start
  sleep 60

  # Create webhook for quality gate through API
  curl -u admin:admin -X POST 'http://sonarqube:9000/api/webhooks/create' -d "name=$WEBHOOK_NAME&url=$WEBHOOK_URL"

  # Create SonarQube token through API
  TOKEN=$(curl -u admin:admin -X POST 'http://sonarqube:9000/api/user_tokens/generate' -d "name=jenkins-token" | jq -r .token)

  # Save token to a file
  echo $TOKEN > $TOKEN_FILE

  # Export the token as an environment variable for Jenkins
  export SONARQUBE_TOKEN=$TOKEN

  # Create the flag file to indicate that the token has been generated
  touch "$FLAG_FILE"
else
  echo "Token has already been generated. Loading from file."
  if [ -f "$TOKEN_FILE" ]; then
    export SONARQUBE_TOKEN=$(cat $TOKEN_FILE)
  else
    echo "Error: Token file not found."
    exit 1
  fi
fi

# Start Jenkins
exec /usr/local/bin/jenkins.sh
