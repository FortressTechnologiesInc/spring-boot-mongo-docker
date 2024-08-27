pipeline {
    agent any
    
    tools {
        jdk 'jdk'
        maven 'maven'
    }
    
    environment {
        SCANNER_HOME = tool 'scanner'
    }
    
    stages {
        stage('1.0 Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        
        stage('2.0 Git Checkout') {
            steps {
                git branch: 'main',  url: 'https://github.com/FortressTechnologiesInc/spring-boot-mongo-docker.git'
            }
        }
        
        stage('3.0 Code Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('4.0 Run Test Cases') {
            steps {
                sh "mvn test"
            }
        }
        
        stage('5.0 Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=Sping-Boot-mongo \
                        -Dsonar.java.binaries=. \
                        -Dsonar.projectKey=Spring-Boot-Mongo '''
                }
            }
        }
        
        stage('6.0 Quality Check') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar'
                }
            }
        }
        
        stage('7.0 OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('8.0 Trivy FS SCAN') {
            steps {
                sh "trivy fs ."
            }
        }
        
        stage('9.0 Maven Build') {
            steps {
                sh "mvn clean compile"
            }
        }
        
        stage('10.0 Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker build -t iscanprint/spingboot:2.0 ."
                        sh "docker push iscanprint/spingboot:2.0"
                        sh "docker rmi -f iscanprint/spingboot:2.0"
                    }
                }
            }
        }
        
        stage('11.0 TRIVY Image Scan') {
            steps {
                sh "trivy image iscanprint/spingboot:2.0 > trivyimage.txt"
            }
        }
        
        stage('12.0 Clean Workspace') {
            steps {
                cleanWs()
            }
        }
    }
    
    post {
        always {
            emailext attachLog: true,
                subject: "'${currentBuild.result}'",
                body: """
                    <html>
                    <body>
                        <div style="background-color: #FFA07A; padding: 15px; margin-bottom: 15px;">
                            <p style="color: white; font-weight: bold;">Project: ${env.JOB_NAME}</p>
                        </div>
                        <div style="background-color: #90EE90; padding: 15px; margin-bottom: 15px;">
                            <p style="color: white; font-weight: bold;">Build Number: ${env.BUILD_NUMBER}</p>
                        </div>
                        <div style="background-color: #87CEEB; padding: 15px; margin-bottom: 15px;">
                            <p style="color: white; font-weight: bold;">URL: ${env.BUILD_URL}</p>
                        </div>
                    </body>
                    </html>
                """,
                to: 'deniferdavies@gmail.com,mokeleke@gmail.com',
                mimeType: 'text/html'
        }
    }
}
