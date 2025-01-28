pipeline {
  agent any
  stages {
    stage('check') {
      steps {
        sh 'gradle check'
        archiveArtifacts(artifacts: 'src/checkstyle/nohttp-checkstyle.xml', fingerprint: true)
      }
    }

    stage('test') {
      steps {
        sh 'gradle test'
      }
    }

    stage('build') {
      steps {
        sh 'gradle build'
      }
    }

  }
}