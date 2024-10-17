pipeline {
  agent any

  tools {
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
        git url: 'https://github.com/phydra-soo/Project_Team1.git',
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
    stage('Docker Image Build') {
      steps {
        echo 'Docker Image build'                
        dir("${env.WORKSPACE}") {
          sh """
          docker build -t phydra/demoreact:$BUILD_NUMBER ./React_404/cvs-app/.
          docker build -t phydra/demospring:$BUILD_NUMBER ./SpringBoot_404/.
          docker tag phydra/demoreact:$BUILD_NUMBER phydra/demoreact:latest
          docker tag phydra/demospring:$BUILD_NUMBER phydra/demospring:latest
          """
        }
      }
    }
    
    stage('Docker Login') {
      steps {
        // docker hub 로그인
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }

    stage('Docker Image Push') {
      steps {
        echo 'Docker Image Push'  
          sh """
          docker push phydra/demoreact:latest
          docker push phydra/demospring:latest
          """  // docker push
      }
    }

    stage('Cleaning up') { 
	    steps { 
        // docker image 제거
        echo 'Cleaning up unused Docker images on Jenkins server'
        sh """
        docker rmi phydra/demoreact:$BUILD_NUMBER
        docker rmi phydra/demoreact:latest
        docker rmi phydra/demospring:$BUILD_NUMBER
        docker rmi phydra/demospring:latest
        """
      }
    }
	  
    stage('Upload S3') {
      steps {
	echo "Upload to S3"
        dir("${env.WORKSPACE}") {
	  sh 'zip -r deploy.zip ./deploy appspec.yml'
          withAWS(region:"${REGION}", credentials: "${AWS_CREDENTIAL_NAME}"){
            s3Upload(file:"deploy.zip", bucket:"team1-codedeploy-bucket")
          }
        sh 'rm -rf ./deploy.zip'
	}
      }
    } 
  }
}
