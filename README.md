# Secure CI/CD

Example of a CI pipeline made in Jenkins that scans a codebase and searches for vulnerabilities with SonarQube and other tools, while implementing a quality gate. Deployment of Jenkins and SonarQube is automated through Docker.

In depth details on how the code works and what it does and how to run it can be found in the `relazione.pdf` file.
Jenkins and its needed dependencies are installed automatically through the init scripts. You just need to access `http://localhost:8080/`, copy the code from `Jenkinsfile` and paste it into a new pipeline.

## Credits

This project was made for the **Systems Safety and Privacy** course of the Technologies of Informatics Systems degree, University Of Bologna.
