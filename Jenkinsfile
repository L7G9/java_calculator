pipeline {
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
        sh "docker build -t lwgregory/java_calculator:${BUILD_TIMESTAMP}"
      }
    }

    stage("Docker push") {
      steps {
        sh "echo to be implemented"
      }
    }

    stage("Update version") {
      steps {
        sh "echo to be implemented"
      }
    }

    stage("Deploy to staging") {
      steps {
        sh "echo to be implemented"
      }
    }

    stage("Acceptance test") {
      steps {
        sh "echo to be implemented"
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
