pipeline {
  environment {
      IMAGEN = "mmarnun/django"
      USUARIO = 'USER_DOCKERHUB'
  }
  agent none
  stages {
      stage("Test") {
          agent {
              docker { image "python:3"
              args '-u root:root'
              }
          }
          stages {
              stage('Clone') {
                  steps {
                      git branch:'main',url:'https://github.com/mmarnun/django_practica.git'
                  }
              }
              stage('Install') {
                  steps {
                      sh 'pip install -r requirements.txt'
                  }
              }
              stage('Test') {
                  steps {
                      sh 'python3 manage.py test'
                  }
              }
          }
      }
      stage("BuildImagenDocker") {
          agent any
          stages {
              stage('Clone') {
                  steps {
                      git branch:'main',url:'https://github.com/mmarnun/django_docker.git'
                  }
              }
              stage('BuildImagen') {
                  steps {
                      script {
                          newApp = docker.build "$IMAGEN:$BUILD_NUMBER"
                      }
                  }
              }
              stage('SubirImagen') {
                  steps {
                      script {
                          docker.withRegistry( '', USUARIO ) {
                              newApp.push()
                          }
                      }
                  }
              }
              stage('RemoveImage') {
                  steps {
                      sh "docker rmi $IMAGEN:$BUILD_NUMBER"
                  }
              }
          }
      }
      stage ('ConexionSSH') {
          steps {
              sshagent(credentials : ['SSH_USER']) {
                  sh 'ssh -o StrictHostKeyChecking=no alex@isrevol.alexnm.es wget https://raw.githubusercontent.com/mmarnun/django_practica/main/docker-compose.yaml -O docker-compose.yaml'
                  sh 'ssh -o StrictHostKeyChecking=no alex@isrevol.alexnm.es docker-compose up -d --force-recreate'
              }
          }
      }
  }
  post {
      always {
          mail to: 'alejandromanuelmartin03@gmail.com',
          subject: "Pipeline: ${currentBuild.fullDisplayName}",
          body: "${env.BUILD_URL} has result ${currentBuild.result}"
      }
  }
}
