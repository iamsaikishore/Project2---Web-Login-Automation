pipeline {
    agent any
    environment {
        ECR_REPO_NAME = "nodeapp"
    }
    stages {
        stage('Check out the repo') {
            steps {
                checkout scm
            }
        }
        stage('Set Release version') {
            steps {
                script {
                    sh 'echo "RELEASE_VERSION=${GITHUB_REF#refs/*/}" >> $GITHUB_ENV'
                }
            }
        }
        stage('Build and push Docker image') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh 'eval $(aws ecr get-login --no-include-email --region ap-south-1)'
                    #$(aws ecr get-login --no-include-email --region ap-south-1)
                    sh 'docker build -t $ECR_REPO_NAME/nodeapp:${RELEASE_VERSION} .'
                    sh 'docker push $ECR_REPO_NAME/nodeapp:${RELEASE_VERSION}'
                }
            }
        }
        stage('Check tag version') {
            steps {
                script {
                    sh 'echo ${RELEASE_VERSION}'
                    sh 'echo ${env.RELEASE_VERSION}'
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
}

