pipeline {

  environment {
    registry = "lwgregory/java_calculator"
    registryCredential = 'DockerHub'
    dockerImage = ''

    PROJECT_ID = 'continuous-delivery-931'
    CLUSTER_NAME = 'calculator-staging'
    LOCATION = 'us-central1-a'
    CREDENTIALS_ID = 'continuous-delivery-931'
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
          dockerImage = docker.build registry + ":${BUILD_TIMESTAMP}"
        }
      }
    }

    stage("Docker push") {
      steps {
        script {
          docker.withRegistry('', registryCredential) {
            dockerImage.push()
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
        projectId: env.PROJECT_ID,
        clusterName: env.CLUSTER_NAME,
        location: env.LOCATION,
        manifestPattern: 'calculator.yaml',
        credentialsId: env.CREDENTIALS_ID,
        verifyDeployments: true])
      }
    }

    stage("Acceptance test") {
      steps {
        sleep 60
        sh "chmod +x acceptance-test.sh && ./acceptance-test.sh"
      }
    }

    // Nonfunctional testing


    stage("Smoke test") {
      steps {
        sh "echo to be implemented"
      }
    }

  }
}
