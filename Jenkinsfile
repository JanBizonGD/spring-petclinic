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

  }
}