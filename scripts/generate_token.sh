#!/bin/sh

SONARQUBE_URL=${SONARQUBE_URL:-http://localhost:9000}
SONARQUBE_ADMIN_USER=${SONARQUBE_ADMIN_USER:-admin}
SONARQUBE_ADMIN_PASSWORD=${SONARQUBE_ADMIN_PASSWORD:-admin}

# Wait for SonarQube to be fully up
until $(curl --output /dev/null --silent --head --fail "$SONARQUBE_URL"); do
  printf '.'
  sleep 5
done

# Generate a new token
SONARQUBE_TOKEN=$(curl -u $SONARQUBE_ADMIN_USER:$SONARQUBE_ADMIN_PASSWORD -X POST "$SONARQUBE_URL/api/user_tokens/generate" -d "name=jenkins-token" | jq -r .token)

echo "SONARQUBE_TOKEN=$SONARQUBE_TOKEN" > /env/token.env

# Pass the token to Jenkins environment
export SONARQUBE_TOKEN
