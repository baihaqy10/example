pipeline {
    agent any

    environment {
        NAMESPACE = "contoh"
        APP_NAME = "contoh-deployment"
        OCP_API = "https://api.cluster-qjwdn.dynamic.redhatworkshops.io:6443/"
        OCP_CREDENTIALS = "sha256~t0XmeLHngR82JXrg9XdzktjzK3WiHg12uB_c9TOnoS0"
    }

        stages {
            stage('Checkout') {
                steps {
                    checkout scm
                }
            }
        }

        stage('Login to OpenShift') {
            steps {
                withCredentials([string(credentialsId: "${OCP_CREDENTIALS}", variable: 'OCP_TOKEN')]) {
                    sh """
                    oc login $OPENSHIFT_API \
                    --token=$OPENSHIFT_CREDENTIALS \
                    --insecure-skip-tls-verify=true
                    oc project ${NAMESPACE}
                    """
                }
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
