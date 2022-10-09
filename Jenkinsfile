pipeline {
  agent { label 'dagger' }
  environment {
    DOCKERHUB_CRED_USR = "shusann01116"
    DOCKERHUB_CRED_PSW = credentials('dockerhub-credential')
  }
  stages {
    stage('build') {
      steps {
        sh '''
          dagger do jenkins --log-format plain
        '''
      }
    }
  }
}
