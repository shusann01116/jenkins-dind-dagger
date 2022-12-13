pipeline {
  agent { label 'dagger' }
  environment {
    DOCKERHUB_CRED_USR = "shusann01116"
    DOCKERHUB_CRED_PSW = ""
  }
  stages {
    stage('build') {
      steps {
        sh '''
          dagger do jenkins agent build --log-format plain
        '''
      }
    }
  }
}
