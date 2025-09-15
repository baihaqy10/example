pipeline {
    agent any

    environment {
        REGISTRY = "registry.example.com"
        IMAGE_NAME = "namespace/contoh-deployment"
        IMAGE_TAG = "latest"
        CREDENTIALS_ID = "docker-registry-creds"
        KUBE_CONTEXT = "openshift-cluster"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://${env.REGISTRY}", CREDENTIALS_ID) {
                        def image = docker.build("${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}")
                        image.push()
                    }
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh "helm upgrade --install contoh-deployment ./helm-chart \
                        --set image.repository=${REGISTRY}/${IMAGE_NAME} \
                        --set image.tag=${IMAGE_TAG} \
                        -n contoh --create-namespace"
                }
            }
        }
    }
}
