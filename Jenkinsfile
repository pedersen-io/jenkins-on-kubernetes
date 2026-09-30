def publishIfMain() {
    if (env.BRANCH_NAME == 'main') {
        withDockerRegistry([credentialsId: 'docker-pat', url: "https://index.docker.io/v1/"]) {
            sh 'make publish-docker'
        }
    }
}

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
    }
    stages {
        stage('Checkout') {
            steps{
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins') {
                    checkout scm
                }
            }
        }
        stage('jenkins-base') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-base')
                    publishIfMain()
                }
            }
        }
        stage('golang') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/golang') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-golang')
                    publishIfMain()
                }
            }
        }
        stage('node') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/node') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-node')
                    publishIfMain()
                }
            }
        }
        stage('dotnetcore') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/dotnetcore') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-dotnetcore')
                    publishIfMain()
                }
            }
        }
        stage('python') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/python') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-python')
                    publishIfMain()
                }
            }
        }
        stage('rust') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/rust') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-rust')
                    publishIfMain()
                }
            }
        }
        stage('c') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/c') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-c')
                    publishIfMain()
                }
            }
        }
        stage('java') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/java') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-java')
                    publishIfMain()
                }
            }
        }
        stage('php') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/php') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-php')
                    publishIfMain()
                }
            }
        }
        stage('ruby') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/ruby') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-ruby')
                    publishIfMain()
                }
            }
        }
        stage('k8s-tooling') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/k8s-tooling') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-k8s-tooling')
                    publishIfMain()
                }
            }
        }
        stage('playwright') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/playwright') {
                    sh 'make build'
                    scanImage('derekpedersen/build-jenkins-playwright')
                    publishIfMain()
                }
            }
        }
        stage('Trivy summary') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins') {
                    generateTrivySummary()
                }
            }
        }

    }
}