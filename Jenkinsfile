pipeline {
    agent any
    
    tools {
        jdk 'jdk'
        maven 'maven'
    }
    
    environment{
        SCANNER_HOME= tool 'scanner'
    }
 stages {
        stage('1.0 clean workspace'){
            steps{
                cleanWs()
            }
        }
    stages {
        stage('Git Checkout ') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/jaiswaladi246/SpringBoot-WebApplication.git'
            }
        }
        
        stage('Code Compile') {
            steps {
                    sh "mvn compile"
            }
        }
        
        stage('Run Test Cases') {
            steps {
                    sh "mvn test"
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                    withSonarQubeEnv('sonar') {
                        sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Sping-Boot-mongo \
                        -Dsonar.java.binaries=. \
                        -Dsonar.projectKey=Spring-Boot-Mongo '''
    
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            steps {
                   dependencyCheck additionalArguments: '--scan ./   ', odcInstallation: 'DP'
                   dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Maven Build') {
            steps {
                    sh "mvn clean compile"
            }
        }
        
        stage('Docker Build & Push') {
            steps {
                   script {
                       withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                            sh "docker build -t iscanprint/spingboot:2.0 ."
                            sh "docker push iscanprint/spingboot:2.0 "
                            sh "docker rmi -f  iscanprint/spingboot:2.0"
                        }
                   } 
            }
        }
        
        stage('Docker Image scan') {
            steps {
                    sh "trivy image iscanprint/spingboot:2.0 "
            }
        }
        
    }
}
