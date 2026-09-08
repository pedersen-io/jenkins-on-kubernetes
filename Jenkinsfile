def publishIfMain() {
    if (env.BRANCH_NAME == 'main') {
        withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
            sh 'make publish-docker'
        }
    }
}

pipeline {
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
                    publishIfMain()
                }
            }
        }
        stage('golang') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/golang') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('node') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/node') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('dotnetcore') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/dotnetcore') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('python') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/python') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('rust') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/rust') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('c') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/c') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('java') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/java') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('php') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/php') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('ruby') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/ruby') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('k8s-tooling') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/k8s-tooling') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
        stage('playwright') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/playwright') {
                    sh 'make build'
                    publishIfMain()
                }
            }
        }
    }
}