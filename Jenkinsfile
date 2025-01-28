pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        sh '''./gradlew check -x test 
'''
        archiveArtifacts(artifacts: 'src/checkstyle/nohttp-checkstyle.xml', fingerprint: true)
      }
    }

    stage('test') {
      steps {
        sh './gradlew test -Pspring.profiles.active=hsqldb,spring-data-jpa'
      }
    }

    stage('build') {
      steps {
        sh './gradlew build  -x test'
      }
    }

    stage('docker build') {
      steps {
        sh '''docker build -t petclinic:latest .
docker tag petclinic host.docker.internal:9092/petclinic:$GIT_COMMIT'''
      }
    }

    stage('docker push') {
      environment {
        nexus_cred = credentials('docker_nexus_repo')
      }
      steps {
        sh 'docker login -u $nexus_cred_USR -p $nexus_cred_PSW'
        sh 'docker push host.docker.internal:9092/petclinic:$GIT_COMMIT'
      }
    }

  }
}