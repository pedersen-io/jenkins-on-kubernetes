def scanImage(String imageName) {
    sh "make scan-image IMAGE_NAME='${imageName}'"
    archiveArtifacts artifacts: '.trivy/reports/*.json, .trivy/reports/*.txt', fingerprint: true, allowEmptyArchive: true
}

def generateTrivySummary() {
    sh 'make trivy-summary'
    archiveArtifacts artifacts: '.trivy/summary/*.html, .trivy/summary/*.md', fingerprint: true, allowEmptyArchive: true
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
        timeout(time: 60, unit: 'MINUTES')
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
                    generateTrivySummary()
                }
            }
        }

    }
}