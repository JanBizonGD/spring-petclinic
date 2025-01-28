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

    stage('build') {
      steps {
        sh './gradlew build  -x test'
      }
    }

    stage('docker build') {
      steps {
        sh '''docker build -t petclinic:latest .
'''
        sh 'docker tag petclinic host.docker.internal:9902/mr/petclinic:$GIT_COMMIT'
      }
    }

    stage('docker push') {
      steps {
        sh 'docker login -u $nexus_cred_USR -p $nexus_cred_PSW http://host.docker.internal:9902'
        sh 'docker push http://host.docker.internal:9902/mr/petclinic:$GIT_COMMIT'
      }
    }

  }
  environment {
    nexus_cred = credentials('docker-nexus-repo')
  }
}