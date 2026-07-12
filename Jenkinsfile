pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    environment {
        AWS_DEFAULT_REGION = 'ap-south-2'
        S3_BUCKET = 'smart-hospital-build-artifacts-ziauddin'

        IMAGE_NAME = 'smart-hospital'
        ECR_REPOSITORY = '245987718650.dkr.ecr.ap-south-2.amazonaws.com/smart-hospital'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Upload Build to S3') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-s3'
                ]]) {
                    sh '''
                        aws s3 sync dist/ s3://$S3_BUCKET --delete
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-s3'
                ]]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin 245987718650.dkr.ecr.ap-south-2.amazonaws.com
                    '''
                }
            }
        }

        stage('Push Image to Amazon ECR') {
            steps {
                sh '''
                    docker tag $IMAGE_NAME:latest $ECR_REPOSITORY:latest
                    docker push $ECR_REPOSITORY:latest
                '''
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh '''
                    docker stop smart-hospital || true
                    docker rm smart-hospital || true

                    docker run -d \
                        --name smart-hospital \
                        -p 8081:80 \
                        $IMAGE_NAME
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Application built, uploaded to S3, pushed to ECR, and deployed successfully.'
        }

        failure {
            echo '❌ Pipeline failed.'
        }
    }
}