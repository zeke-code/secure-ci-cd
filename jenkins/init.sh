#!/bin/bash

FLAG_FILE="/var/jenkins_home/sonarqube_token_generated.flag"
TOKEN_FILE="/var/jenkins_home/sonarqube_token.env"
WEBHOOK_NAME="jenkins"
WEBHOOK_URL="http://jenkins:8080/sonarqube-webhook"
QUALITY_GATE_NAME="Online Book Store"

# Check if the token has already been generated
if [ ! -f "$FLAG_FILE" ]; then

  # Make API request to check SonarQube's state
  STATUS=$(curl -u admin:admin -X GET 'http://sonarqube:9000/api/system/status' | jq -r .status)

  while [ "$STATUS" != "UP" ]; do
    echo "Waiting for SonarQube to fully initialize..."
    sleep 10
    STATUS=$(curl -u admin:admin -X GET 'http://sonarqube:9000/api/system/status' | jq -r .status)
  done

  echo "SonarQube is up! Initializing API calls..."

  # Create webhook for quality gate through API
  curl -u admin:admin -X POST 'http://sonarqube:9000/api/webhooks/create' -d "name=$WEBHOOK_NAME&url=$WEBHOOK_URL"

  # Create SonarQube token through API
  TOKEN=$(curl -u admin:admin -X POST 'http://sonarqube:9000/api/user_tokens/generate' -d "name=jenkins-token" | jq -r .token)

  # Export the token as an environment variable for Jenkins
  export SONARQUBE_TOKEN=$TOKEN

  # Create quality gate
  curl -u admin:admin -X POST 'http://sonarqube:9000/api/qualitygates/create' -d "name=$QUALITY_GATE_NAME"

  # Get the quality gate ID
  QUALITY_GATE_ID=$(curl -u admin:admin -X GET 'http://sonarqube:9000/api/qualitygates/list' | jq -r ".qualitygates[] | select(.name==\"$QUALITY_GATE_NAME\") | .id")

  # Create conditions for the quality gate
  curl -u admin:admin -X POST 'http://sonarqube:9000/api/qualitygates/create_condition' -d "gateId=$QUALITY_GATE_ID" -d "metric=bugs" -d "op=GT" -d "error=0"

  # Set the new quality gate as default
  curl -u admin:admin -X POST 'http://sonarqube:9000/api/qualitygates/set_as_default' -d "name=$QUALITY_GATE_NAME"

  # Create the flag file to indicate that the token has been generated
  touch "$FLAG_FILE"
else
  echo "Token has already been generated. Loading from file."
fi

# Start Jenkins
exec /usr/local/bin/jenkins.sh
