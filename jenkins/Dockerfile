FROM jenkins/jenkins:lts

# Install Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Skip the initial setup wizard
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false

# Copy JCasC configuration file
COPY casc.yaml /var/jenkins_home/casc.yaml

# Configure Jenkins to use JCasC
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc.yaml

# Install Maven
USER root
RUN apt-get update && apt-get install -y maven

# Install Node.js (SonarQube scanner dependency)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Install jq
RUN apt-get update && apt-get install -y jq

# Copy the script into the container
COPY init.sh /usr/local/bin/init.sh

# Make the script executable
RUN chmod +x /usr/local/bin/init.sh

USER jenkins

# Define the entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]
