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

        stage('Install Helm') {
            steps {
                sh """
                curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz
                tar -xzf helm.tar.gz
                mkdir -p \$WORKSPACE/bin
                mv linux-amd64/helm \$WORKSPACE/bin/helm
                export PATH=\$WORKSPACE/bin:\$PATH
                \$WORKSPACE/bin/helm version
                """
            }
        }
    }
}