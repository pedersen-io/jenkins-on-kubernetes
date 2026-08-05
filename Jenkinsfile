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
                    withDockerRegistry([credentialsId: 'derekpedersen_docker', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                    // GCR publish removed for Docker Hub migration
                }
            }
        }
        stage('golang') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/golang') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'derekpedersen_docker', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                    // GCR publish removed for Docker Hub migration
                }
            }
        }
        stage('node') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/node') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'derekpedersen_docker', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                    // GCR publish removed for Docker Hub migration
                }
            }
        }
        stage('dotnetcore') {
            steps {
                dir('/root/workspace/go/src/github.com/derekpedersen/gke-jenkins/dotnetcore') {
                    sh 'make build'
                    withDockerRegistry([credentialsId: 'derekpedersen_docker', url: "https://index.docker.io/v1/"]) {
                        sh 'make publish-docker'
                    }
                    // GCR publish removed for Docker Hub migration
                }
            }
        }
    }
}