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
    BUCKET = "team1-codedeploy-bucket"
    ZIP_NAME = "scripts.zip"
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
          docker build -t phydra/team1react:$BUILD_NUMBER ./React_404/cvs-app/.
          docker build -t phydra/team1spring:$BUILD_NUMBER ./SpringBoot_404/.
          docker tag phydra/team1react:$BUILD_NUMBER phydra/team1react:latest
          docker tag phydra/team1spring:$BUILD_NUMBER phydra/team1spring:latest
          """
        }
      }
    }
    
    stage('Docker Login') {
      steps {
        // docker hub 로그인
	echo 'Docker Login'
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }

    stage('Docker Image Push') {
      steps {
        echo 'Docker Image Push'  
          sh """
          docker push phydra/team1react:latest
          docker push phydra/team1spring:latest
          """  // docker push
      }
    }

    stage('Cleaning up') { 
	    steps { 
        // docker image 제거
        echo 'Cleaning up unused Docker images on Jenkins server'
        sh """
        docker rmi phydra/team1react:$BUILD_NUMBER
        docker rmi phydra/team1react:latest
        docker rmi phydra/team1spring:$BUILD_NUMBER
        docker rmi phydra/team1spring:latest
        """
      }
    }
	  
    stage('Upload S3') {
      steps {
	echo "Upload to S3"
        dir("${env.WORKSPACE}") {
	  sh 'zip -r scripts.zip ./scripts appspec.yml'
          withAWS(region:"${REGION}", credentials: "${AWS_CREDENTIAL_NAME}"){
            s3Upload(file:"scripts.zip", bucket:"team1-codedeploy-bucket")
          }
        sh 'rm -rf ./scripts.zip'
	}
      }
    }
    stage('Codedeploy workload') {
      steps {
	echo "create code-deploy group"
	withAWS(region:"${REGION}", credentials: "${AWS_CREDENTIAL_NAME}") {      
	  sh """
 	  aws deploy create-deployment-group \
  	  --application-name team1-code-deploy \
   	  --auto-scaling-groups Team1-target-asg \
    	  --deployment-group-name team1-code-deploy-${BUILD_NUMBER} \
     	  --deployment-config-name CodeDeployDefault.OneAtATime \
      	  --service-role-arn arn:aws:iam::491085389788:role/Team1-code-deploy-sevice-role \
	  """
	  echo "codedeploy workload"
	  sh """
   	  aws deploy create-deployment --application-name team1-code-deploy \
      	  --deployment-config-name CodeDeployDefault.OneAtATime \
	  --deployment-group-name team1-code-deploy-${BUILD_NUMBER} \
	  --s3-location bucket=${BUCKET},bundleType=zip,key=${zip_name}
       	  """
	  sleep(10)
	}
      }    
    }
  }
}
