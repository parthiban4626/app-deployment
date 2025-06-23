pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'parthiban46/dev-app:latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Cloning repo...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo '🔐 Logging into Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo '📦 Pushing image to Docker Hub...'
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy on App VM') {
            steps {
                echo '🚀 Deploying on App EC2...'
                withCredentials([sshUserPrivateKey(credentialsId: 'app-ssh', keyFileVariable: 'KEY')]) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i "$KEY" ec2-user@43.204.115.62 "
                            docker rm -f react-app || true && \
                            docker pull $DOCKER_IMAGE && \
                            docker run -d -p 80:80 --name react-app $DOCKER_IMAGE
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Build or Deployment Failed!'
        }
    }
}
