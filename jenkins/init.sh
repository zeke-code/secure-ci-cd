#!/bin/bash

FLAG_FILE="/var/jenkins_home/sonarqube_token_generated.flag"
TOKEN_FILE="/var/jenkins_home/sonarqube_token.env"
WEBHOOK_NAME="jenkins"
WEBHOOK_URL="http://jenkins:8080/sonarqube-webhook"

# Check if the token has already been generated
if [ ! -f "$FLAG_FILE" ]; then

<<COMMENT
  Wait 80 seconds for SonarQube container to start (This time is enough for most machines to get SonarQube container fully running).
  This method to handle this is indeed VERY ugly but it's the only doable way, since SonarQube's API to check if the system is fully
  up and running doesn't give enough information regarding SonarQube's Web API state.
  Making any kind of HTTP request to SonarQube's web API while the container is still starting results in multiple errors.
  So yeah. This is the way to do this. I know, very ugly, but SonarQube's software is an absolute menace to work with.
COMMENT

  sleep 80

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
