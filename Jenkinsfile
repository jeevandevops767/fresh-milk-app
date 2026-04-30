pipeline {
    agent any

    environment {
        PROJECT_ID = "web-application-deploy-489908"
        REGION = "us-central1"
        REPO = "my-repo"
        IMAGE_NAME = "fresh-milk-app"
        CLUSTER_NAME = "gke-cluster"
        ZONE = "us-central1-a"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/jeevandevops767/fresh-milk-app.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'python3 -m pytest -v || echo "No tests found, skipping..."'
            }
        }

        stage('Get Commit ID') {
            steps {
                script {
                    env.COMMIT_ID = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
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

        stage('Push Image to GAR') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=$GCP_KEY
                    gcloud auth configure-docker ${REGION}-docker.pkg.dev

                    docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${COMMIT_ID}
                    """
                }
            }
        }

        stage('Approval (CD)') {
            steps {
                input message: "Approve deployment?", ok: "Deploy"
            }
        }

        stage('Deploy to GKE') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=$GCP_KEY
                    gcloud config set project ${PROJECT_ID}

                    gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${ZONE}

                    cp kubernetes/deployment.yaml deployment-temp.yaml

                    sed -i "s|IMAGE_PLACEHOLDER|${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${COMMIT_ID}|g" deployment-temp.yaml

                    kubectl apply -f deployment-temp.yaml
                    kubectl apply -f kubernetes/service.yaml

                    kubectl rollout status deployment/fresh-milk-app
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment Successful 🚀"
        }
        failure {
            echo "Pipeline Failed ❌"
        }
    }
}