pipeline {
    agent { label 'dagger' }

    environment {
      DOCKERHUB_CRED_USR = credentials('dockerhub-credential')
      DOCKERHUB_CRED_PSW = credentials('dockerhub-credential')
    }
    stages {
      stage('build') {
        steps {
          sh '''
            dagger do agent build
          '''
        }
      }
    }
}
