pipeline {
    agent any

    stages {
        stage ('Check-out') {
            steps {
                echo ('Cloning repository')
                git 'https://github.com/shashirajraja/onlinebookstore.git'
            }
        }

        stage ('Build') {
            steps {
                echo ('Building project with Maven...')
                withMaven(maven: 'maven3') {
                    sh 'mvn build'
                }
            }
        }
    }
}