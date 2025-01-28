pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        sh './gradlew check'
        archiveArtifacts(artifacts: 'src/checkstyle/nohttp-checkstyle.xml', fingerprint: true)
      }
    }

    stage('test') {
      steps {
        sh './gradlew test'
      }
    }

    stage('build') {
      steps {
        sh './gradlew build'
      }
    }

    stage('docker build') {
      steps {
        sh '''docker build -t petclinic:latest .
docker tag petclinic http://host.docker.internal:9092/petclinic:$GIT_COMMIT'''
      }
    }

    stage('docker push') {
      environment {
        bindings = 'nexus_docker_repo'
      }
      steps {
        sh 'docker push http://host.docker.internal:9092/petclinic:$GIT_COMMIT'
      }
    }

  }
}