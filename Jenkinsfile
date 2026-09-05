pipeline {
    agent {
        label 'build-base-stable'
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
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('golang') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/golang') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('node') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/node') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('dotnetcore') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/dotnetcore') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('python') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/python') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('rust') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/rust') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('c') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/c') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('java') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/java') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('php') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/php') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('ruby') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/ruby') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('k8s-tooling') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/k8s-tooling') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
        stage('playwright') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/playwright') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                }
            }
        }
    }
}