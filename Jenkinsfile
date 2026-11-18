def scanImage(String imageName) {
    sh "make scan-image IMAGE_NAME='${imageName}'"
    archiveArtifacts artifacts: '.trivy/reports/*.json, .trivy/reports/*.txt', fingerprint: true, allowEmptyArchive: true

    sh """
        set -eu
        mkdir -p .trivy/sbom .trivy/digests
        IMAGE_NAME='${imageName}'
        SAFE_NAME="$(printf '%s' "$IMAGE_NAME" | tr '/' '-')"
        trivy image --format cyclonedx --output ".trivy/sbom/\${SAFE_NAME}.cdx.json" "\${IMAGE_NAME}:latest" || true
        docker image inspect --format='{{index .RepoDigests 0}}' "\${IMAGE_NAME}:latest" > ".trivy/digests/\${SAFE_NAME}.digest.txt" || true
    """
    archiveArtifacts artifacts: '.trivy/sbom/*.cdx.json, .trivy/digests/*.digest.txt', fingerprint: true, allowEmptyArchive: true
}

def generateTrivySummary() {
    sh 'make trivy-summary'
    archiveArtifacts artifacts: '.trivy/summary/*.html, .trivy/summary/*.md', fingerprint: true, allowEmptyArchive: true
}

def aggregateSecurityArtifacts() {
    sh '''
        set -eu
        mkdir -p .trivy/aggregate/sbom .trivy/aggregate/digests

        find . -type f -path '*/.trivy/sbom/*.cdx.json' -exec cp {} .trivy/aggregate/sbom/ \; || true
        find . -type f -path '*/.trivy/digests/*.digest.txt' -exec cp {} .trivy/aggregate/digests/ \; || true
    '''
    archiveArtifacts artifacts: '.trivy/aggregate/sbom/*.cdx.json, .trivy/aggregate/digests/*.digest.txt', fingerprint: true, allowEmptyArchive: true
}

pipeline {
    triggers {
        cron('0 12 * * 1')
    }
    agent {
        label 'build-jenkins-base'
    }
    options {
        skipDefaultCheckout true
        timeout(time: 180, unit: 'MINUTES')
    }
    environment {
        PROJECT_DIR = '.'
    }
    stages {
        stage('Checkout') {
            steps {
                dir("${env.PROJECT_DIR}") {
                    checkout scm
                }
            }
        }
        stage('jenkins-base') {
            steps {
                dir("${env.PROJECT_DIR}") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-base')
                }
            }
        }
        stage('golang') {
            steps {
                dir("${env.PROJECT_DIR}/golang") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-golang')
                }
            }
        }
        stage('node') {
            steps {
                dir("${env.PROJECT_DIR}/node") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-node')
                }
            }
        }
        stage('dotnetcore') {
            steps {
                dir("${env.PROJECT_DIR}/dotnetcore") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-dotnetcore')
                }
            }
        }
        stage('dotnetcore-preview') {
            steps {
                dir("${env.PROJECT_DIR}/dotnetcore/preview") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-dotnetcore-preview')
                }
            }
        }
        stage('python') {
            steps {
                dir("${env.PROJECT_DIR}/python") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-python')
                }
            }
        }
        stage('rust') {
            steps {
                dir("${env.PROJECT_DIR}/rust") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-rust')
                }
            }
        }
        stage('c') {
            steps {
                dir("${env.PROJECT_DIR}/c") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-c')
                }
            }
        }
        stage('java') {
            steps {
                dir("${env.PROJECT_DIR}/java") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-java')
                }
            }
        }
        stage('php') {
            steps {
                dir("${env.PROJECT_DIR}/php") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-php')
                }
            }
        }
        stage('ruby') {
            steps {
                dir("${env.PROJECT_DIR}/ruby") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-ruby')
                }
            }
        }
        stage('k8s-tooling') {
            steps {
                dir("${env.PROJECT_DIR}/k8s-tooling") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-k8s-tooling')
                }
            }
        }
        stage('playwright') {
            steps {
                dir("${env.PROJECT_DIR}/playwright") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-playwright')
                }
            }
        }
        stage('terraform') {
            steps {
                dir("${env.PROJECT_DIR}/terraform") {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-terraform')
                }
            }
        }
        stage('Trivy summary') {
            steps {
                dir("${env.PROJECT_DIR}") {
                    aggregateSecurityArtifacts()
                    generateTrivySummary()
                }
            }
        }

    }
}