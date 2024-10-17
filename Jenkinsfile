pipeline {
  agent any

  tool {
    jdk 'jdk17'
    gradle 'G3'
  }
  
  environment { 
    // jenkins에 등록해 놓은 docker hub credentials 이름
    DOCKERHUB_CREDENTIALS = credentials('dockerCredentials') 
    REGION = "ap-northeast-2"
    AWS_CREDENTIAL_NAME = 'AWSCredentials'
  }

  stages {
    stage('Git Clone') {
      steps {
        echo 'Git Clone'
        git url: 'https://github.com/phydra-soo/Project_Team1.git'
        branch: 'main', credentialsId: 'gitToken' 
      }
      post {
        success {
          echo 'Success git clone step'
        }
        failure {
          echo 'Fail git clone step'
        }
      }
    }

    stage('Gradle Build') {
      steps {
        echo 'Gradle Build'
        sh 'sh command_Spring.sh'
        
      }
    }

    
  }






}
