pipeline {
    agent any

    environment {
        NAMESPACE = "contoh"
        APP_NAME = "contoh-deployment"
        OCP_API = "https://api.cluster-qjwdn.dynamic.redhatworkshops.io:6443/"
        OCP_CREDENTIALS = "sha256~wPdVM5tZY1I80kbZNm2-FeAlmZk2OlGm8ANT0aMu01s"
    }

 stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Login to OpenShift') {
            steps {
                    sh """
                    oc login ${OCP_API} --token=${OCP_CREDENTIALS} --insecure-skip-tls-verify=true
                    oc project ${NAMESPACE}
                    """
            }
        }

        stage('Ensure BuildConfig exists') {
            steps {
                sh """
                if ! oc get bc ${APP_NAME} -n ${NAMESPACE}; then
                  oc new-build --name=${APP_NAME} --binary --strategy=docker -n ${NAMESPACE}
                fi
                """
            }
        }

        stage('Build in OpenShift') {
            steps {
                sh """
                oc start-build ${APP_NAME} --from-dir=. --follow -n ${NAMESPACE}
                """
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh """
                helm upgrade --install ${APP_NAME} ./helm-chart \\
                  --set image.repository=image-registry.openshift-image-registry.svc:5000/${NAMESPACE}/${APP_NAME} \\
                  --set image.tag=latest \\
                  -n ${NAMESPACE} --create-namespace
                """
            }
        }
    }
}