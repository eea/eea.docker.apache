pipeline {
  agent any

  environment {
    GIT_NAME = "eea.docker.apache"
    registry = "eeacms/apache"
  }

  
  stages {
 
    stage('Build, Test & Push ( on tag )') {
      when {
        anyOf {
          buildingTag()
          branch 'master'
        }
      }
      steps{
        node(label: 'docker-big-jobs') {
          script {
            checkout scm
            if (env.BRANCH_NAME == 'master') {
              tagName = 'latest'
            } else {
              tagName = "$BRANCH_NAME".toLowerCase()
            }
            // build under a unique tag so the tests run on this build, never on a pulled image
            buildTag = "$tagName-build$BUILD_NUMBER"
            try {
              dockerImage = docker.build("$registry:$buildTag", "--no-cache .")
              sh "./test/run.sh $registry:$buildTag"
              docker.withRegistry( '', 'eeajenkins' ) {
                dockerImage.push(tagName)
              }
            } finally {
              sh "docker rmi $registry:$buildTag $registry:$tagName || true"
            }
          }
        }
      }
    }

    
    stage('Release on tag creation') {
      when {
        buildingTag()
      }
      steps{
        node(label: 'docker') {
          withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GITHUB_TOKEN'),  string(credentialsId: 'plone-backend-trigger', variable: 'TRIGGER_MAIN_URL'), usernamePassword(credentialsId: 'jekinsdockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
           sh '''docker pull eeacms/gitflow; docker run -i --rm --name="$BUILD_TAG"  -e GIT_BRANCH="$BRANCH_NAME" -e GIT_NAME="$GIT_NAME" -e DOCKERHUB_REPO="eeacms/apache" -e GIT_TOKEN="$GITHUB_TOKEN" -e DOCKERHUB_USER="$DOCKERHUB_USER" -e DOCKERHUB_PASS="$DOCKERHUB_PASS"  -e TRIGGER_MAIN_URL="$TRIGGER_MAIN_URL" -e DEPENDENT_DOCKERFILE_URL="eea/eea.docker.apache-eea-www/blob/develop/Dockerfile" -e DOCKERHUB_REPO_SUFIX="-alpine" -e GITFLOW_BEHAVIOR="RUN_ON_TAG" -e RANCHER_CATALOG_ADD_MINUS="yes"  eeacms/gitflow'''
         }

        }
      }
    }


 }

  post { 
    always {
      cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true)
    }
    changed {
      script {
        def details = """<h1>${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - ${currentBuild.currentResult}</h1>
                         <p>Check console output at <a href="${env.BUILD_URL}/display/redirect">${env.JOB_BASE_NAME} - #${env.BUILD_NUMBER}</a></p>
                      """
        emailext(
        subject: '$DEFAULT_SUBJECT',
        body: details,
        attachLog: true,
        compressLog: true,
        recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']]
        )
      }
    }
  }
}
