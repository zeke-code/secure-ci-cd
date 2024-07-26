FROM jenkins/jenkins:lts

# Skip the initial setup wizard
ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false

# Install needed plugins through Jenkins CLI
RUN jenkins-plugin-cli --plugins \
  sonar:2.17.2 \
  blueocean:1.27.14 \
  git:5.2.2 \
  pipeline-maven:1421.v610fa_b_e2d60e \
  configuration-as-code:1836.vccda_4a_122a_a_e

# Copy JCasC configuration file
COPY casc.yaml /var/jenkins_home/casc.yaml

# Configure Jenkins to use JCasC
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc.yaml
