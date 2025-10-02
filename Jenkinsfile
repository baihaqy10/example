pipeline {
    agent any

    environment {
        NAMESPACE = "contoh-deployment"
        APP_NAME = "contoh-deployment"
        OCP_API = "https://api.cluster-djc54.dynamic.redhatworkshops.io:6443"
        OCP_CREDENTIALS = "sha256~2hEskbEVKsj11g3X62B7bBUfcfznJd48juTHY0oNXvs"  // sebaiknya pakai Jenkins Credentials, bukan hardcode
        HELM_VERSION = "v3.15.4"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('login') {
            steps {
                sh """
                oc login ${OCP_API} --token=${OCP_CREDENTIALS} --insecure-skip-tls-verify=true
                if ! oc get project ${NAMESPACE} >/dev/null 2>&1; then
                    oc new-project ${NAMESPACE} --description="Project for ${APP_NAME}"
                fi
                """
            }
        }

        stage('buildconfig') {
            steps {
                sh """
                if ! oc get bc ${APP_NAME} -n ${NAMESPACE}; then
                  oc new-build --name=${APP_NAME} --binary --strategy=docker -n ${NAMESPACE}
                fi
                """
            }
        }

        stage('build openshift') {
            steps {
                sh """
                oc start-build ${APP_NAME} --from-dir=. --follow -n ${NAMESPACE}
                """
            }
        }

        stage('install helm bogo') {
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

        stage('deploy') {
            steps {
                sh """
                export PATH=\$WORKSPACE/bin:\$PATH
                helm upgrade --install ${APP_NAME} ./helm-chart \\
                  --set image.repository=image-registry.openshift-image-registry.svc:5000/${NAMESPACE}/${APP_NAME} \\
                  --set image.tag=latest \\
                  -n ${NAMESPACE} --create-namespace
                """
            }
        }

        stage('rollout') {
            steps {
                script {
                    sh """
                    oc rollout restart deployment ${APP_NAME} -n ${NAMESPACE}
                    """
                }
            }
        }
    }
}
