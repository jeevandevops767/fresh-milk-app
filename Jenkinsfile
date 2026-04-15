pipeline {
    agent any

    environment {
        PROJECT_ID = "web-application-deploy-489908"
        REGION = "us-central1"
        REPO = "my-repo"
        IMAGE_NAME = "fresh-milk-app"
        CLUSTER_NAME = "jeeva-cluster"
        ZONE = "us-central1-a"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/jeevandevops767/fresh-milk-app.git'
            }
        }

        stage('Get Commit ID') {
            steps {
                script {
                    COMMIT_ID = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.COMMIT_ID = COMMIT_ID
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${COMMIT_ID} ."
            }
        }

        stage('Tag Image') {
            steps {
                sh """
                docker tag ${IMAGE_NAME}:${COMMIT_ID} \
                ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${COMMIT_ID}
                """
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=$GCP_KEY
                    gcloud auth configure-docker ${REGION}-docker.pkg.dev

                    docker push \
                    ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${COMMIT_ID}
                    """
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=$GCP_KEY
                    gcloud config set project ${PROJECT_ID}

                    gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${REGION}

                    sed -i "s|IMAGE_PLACEHOLDER|${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${COMMIT_ID}|g kubernetes/deployment.yaml 

                    kubectl apply -f kubernetes/deployment.yaml
                    kubectl apply -f kubernetes/service.yaml
                    """
                }
            }
        }
    }
}
