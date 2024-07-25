FROM jenkins/jenkins:lts

# Skip the initial setup wizard
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false

# Install needed plugins through Jenkins CLI
RUN jenkins-plugin-cli --plugins \
  sonar:2.17.2 \
  blueocean:1.27.14 \
  git:5.2.2 \
  configuration-as-code:1836.vccda_4a_122a_a_e
  
