pipeline {
    agent { label 'dagger' }

    environment {
        GREETING = 'Hello there, Jenkins! Hello!'
      }
    stages {
        sh '''
          dagger do hello
        '''
    }
}
