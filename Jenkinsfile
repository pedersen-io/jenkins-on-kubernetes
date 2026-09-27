def publishIfMain() {
    if (env.BRANCH_NAME == 'main') {
        withDockerRegistry([credentialsId: 'docker-jenkins-pat', url: "https://index.docker.io/v1/"]) {
            sh 'make publish-docker'
        }
    }
}

def scanImage(String imageName) {
    sh """
        mkdir -p trivy-reports
        if ! command -v trivy >/dev/null 2>&1; then
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        fi
        trivy image --severity HIGH,CRITICAL --ignore-unfixed --format json --output trivy-reports/${imageName.replaceAll('/', '-')}.json ${imageName}:latest || true
        trivy image --severity HIGH,CRITICAL --ignore-unfixed --format table --output trivy-reports/${imageName.replaceAll('/', '-')}.txt ${imageName}:latest || true
        trivy image --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 ${imageName}:latest
    """
    publishHTML(target: [
        allowMissing: true,
        alwaysLinkToLastBuild: true,
        keepAll: true,
        reportDir: 'trivy-reports',
        reportFiles: "${imageName.replaceAll('/', '-')}.txt",
        reportName: "Trivy scan - ${imageName.replaceAll('/', '-')}",
        reportTitles: "Trivy scan - ${imageName.replaceAll('/', '-')}"])
    archiveArtifacts artifacts: 'trivy-reports/*.json, trivy-reports/*.txt', fingerprint: true
}

def generateTrivySummary() {
    sh '''
        mkdir -p trivy-summary
        html=trivy-summary/index.html
        {
            echo '<html><head><title>Trivy image scan summary</title>'
            echo '<style>body { font-family: Arial, sans-serif; margin: 2rem; } ul { line-height: 1.8; } a { text-decoration: none; color: #0b57d0; } a:hover { text-decoration: underline; } </style>'
            echo '</head><body>'
            echo '<h1>Trivy image scan summary</h1>'
            echo '<ul>'
            while IFS= read -r report; do
                rel="${report#./}"
                echo "<li><a href=\"../${rel}\">${rel}</a></li>"
            done < <(find . -path '*/trivy-reports/*.txt' | sort)
            echo '</ul>'
            echo '</body></html>'
        } > "$html"
    '''
    publishHTML(target: [
        allowMissing: true,
        alwaysLinkToLastBuild: true,
        keepAll: true,
        reportDir: 'trivy-summary',
        reportFiles: 'index.html',
        reportName: 'Trivy scan summary',
        reportTitles: 'Trivy scan summary'])
    archiveArtifacts artifacts: 'trivy-summary/index.html', fingerprint: true
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