pipeline {

  environment {
    DH_REGISTRY = "lwgregory/java_calculator"
    DH_CREDENTIAL = 'DockerHub'
    DOCKER_IMAGE = ''

    GKE_PROJECT_ID = 'java-calculator-357920'
    GKE_STAGING_CLUSTER_NAME = 'staging'
    GKE_PRODUCTION_CLUSTER_NAME = 'production'
    GKE_LOCATION = 'us-central1-a'
    GKE_CREDENTIALS_ID = 'java-calculator'
    GKE_SERVICE_ACCOUNT = 'jenkins@java-calculator-357920.iam.gserviceaccount.com'
  }

  agent any

  stages {

    stage("Compile") {
      steps {
        sh "./gradlew compileJava"
      }
    }

    stage("Unit test") {
      steps {
        sh "./gradlew test"
      }
    }

    stage("Code coverage") {
      steps {
        sh "./gradlew jacocoTestReport"
        publishHTML (target: [
          reportDir: 'build/reports/jacoco/test/html',
          reportFiles: 'index.html',
          reportName: "JaCoCo Report"
        ])
        sh "./gradlew jacocoTestCoverageVerification"
      }
    }

    stage("Static code analysis") {
      steps {
        sh "./gradlew checkstyleMain"
        publishHTML (target: [
          reportDir: 'build/reports/checkstyle',
          reportFiles: 'main.html',
          reportName: "Checkstyle Report"
        ])
      }
    }

    stage("Build") {
      steps {
        sh "./gradlew build"
      }
    }

    stage("Docker build") {
      steps {
        script {
          DOCKER_IMAGE = docker.build DH_REGISTRY + ":${BUILD_TIMESTAMP}"
        }
      }
    }

    stage("Docker push") {
      steps {
        script {
          docker.withRegistry('', DH_CREDENTIAL) {
            DOCKER_IMAGE.push()
          }
        }
      }
    }

    stage("Update version") {
      steps {
        sh "sed -i 's/{{VERSION}}/${BUILD_TIMESTAMP}/g' calculator.yaml"
      }
    }

    stage("Deploy to staging") {
      steps {
        step([
        $class: 'KubernetesEngineBuilder',
        projectId: env.GKE_PROJECT_ID,
        clusterName: env.GKE_STAGING_CLUSTER_NAME,
        location: env.GKE_LOCATION,
        manifestPattern: 'calculator.yaml',
        credentialsId: env.GKE_CREDENTIALS_ID,
        verifyDeployments: true])
      }
    }

    stage("Acceptance test") {
      steps {
        sleep 60

        sh "gcloud config set project ${GKE_PROJECT_ID}"        
        withCredentials([file(credentialsId: 'key-gcloud-sa', variable: 'GC_KEY')]) {
          sh("gcloud auth activate-service-account --key-file=${GC_KEY}")
          sh("gcloud container clusters get-credentials ${GKE_STAGING_CLUSTER_NAME} --zone ${GKE_LOCATION} --project ${GKE_PROJECT_ID}")
        }

        sh "chmod +x acceptance-test.sh && ./acceptance-test.sh"
      }
    }

    // Nonfunctional testing
    stage("Performance test") {
      steps {
	sh "./gradlew jmRun"
	prefReport 'build/jmeter-report/*.csv'
      }
    }

    stage("Deploy to production") {
      steps {
        step([
        $class: 'KubernetesEngineBuilder',
        projectId: env.GKE_PROJECT_ID,
        clusterName: env.GKE_PRODUCTION_CLUSTER_NAME,
        location: env.GKE_LOCATION,
        manifestPattern: 'calculator.yaml',
        credentialsId: env.GKE_CREDENTIALS_ID,
        verifyDeployments: true])
      }
    }

    stage("Smoke test") {
      steps {
	sleep 60

        withCredentials([file(credentialsId: 'key-gcloud-sa', variable: 'GC_KEY')]) {
          sh("gcloud container clusters get-credentials ${GKE_PRODUCTION_CLUSTER_NAME} --zone ${GKE_LOCATION} --project ${GKE_PROJECT_ID}")
        }

        sh "./acceptance-test.sh"
      }
    }
  }
}
