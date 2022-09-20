# java_calculator
CI/CD pipeline for a simple web service

## Description
CI/CD pipeline for a simple web service created with Java & Springboot which is deployed using Docker and Kubernetes on GCP.  
The pipline has the following stages...
- Compile
- Unit tests
- Code coverage using JaCoCo
- Static code analysis using Checkstyle
- Build
- Docker build and push
- Deploy to staging on Google Kubernetes Engine
- Acceptance test using Cucumber
- Performance tests using JMeter
- Deploy to production on Google Kubernetes Engine
- Smoke test

## Usage
Add following credentials to Jenkins...
- GitHub
- DockerHub
- Google Cloud Platform

In Jenkins...
- Create pipline
- Set Definition as script from SCM
- Set SCM as git
- Set Script Path as Jenkinsfile

### Author Information
lukewgregory@gmail.com
