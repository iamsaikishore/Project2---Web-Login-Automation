pipeline {
    agent any
    environment {
        ECR_REPO_NAME = "413497891764.dkr.ecr.ap-south-1.amazonaws.com"
        RELEASE_VERSION="v1.$BUILD_NUMBER"
    }
    stages {
        
        stage('Check out the repo') {
            steps {
                git 'https://github.com/iamsaikishore/Project2---Web-Login-Automation.git'
            }
        }
        
        stage('Build and push Docker image') {
            steps {
                withAWS(credentials: '	kichu-access-keys', region: 'ap-south-1') {
                    sh 'aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin $ECR_REPO_NAME'
                    sh 'docker build -t nodeapp .'
                    sh 'docker tag nodeapp:latest $ECR_REPO_NAME/nodeapp:${RELEASE_VERSION}'
                    sh 'docker push $ECR_REPO_NAME/nodeapp:${RELEASE_VERSION}'
                }
            }
        }
        
        stage('Check tag version') {
            steps {
                script {
                    sh 'echo ${RELEASE_VERSION}'
                }
            }
        }
        
        stage('Terraform initialization') {
            steps {
                dir('devops/') {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform deployment') {
            steps {
                sh 'cd devops && terraform apply -var="tag=${RELEASE_VERSION}" -auto-approve'
            }
        }
    }
}
