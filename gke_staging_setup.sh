#!/bin/bash

# Set environment
export PROJECT=$(gcloud info --format='value(config.project)')
export CLUSTER=calculator-staging
export ZONE=us-central1-a
export SA=staging-sa
export SA_EMAIL=${SA}@${PROJECT}.iam.gserviceaccount.com
mkdir rbac

# Enable GCP APIs
gcloud services enable compute.googleapis.com \
container.googleapis.com \
servicemanagement.googleapis.com \
cloudresourcemanager.googleapis.com \
    --project $PROJECT

# Create cluster if needed
# gcloud container clusters create $CLUSTER --zone $ZONE

# Retrieve KubeConfig for cluster
gcloud container clusters get-credentials $CLUSTER --zone $ZONE

#--- Configure GCP Service Account Permissions ---
# Create a service account
gcloud iam service-accounts create $SA

# Create custom GCP IAM Role with minimal permissions using the custom role defined within rbac/IAMrole.yaml
curl https://raw.githubusercontent.com/jenkinsci/google-kubernetes-engine-plugin/develop/docs/rbac/IAMrole.yaml >> rbac/IAMrole.yaml
gcloud iam roles create gke_deployer --project $PROJECT --file \
rbac/IAMrole.yaml

# Grant the IAM role to your GCP service account
gcloud projects add-iam-policy-binding $PROJECT \
--member serviceAccount:$SA_EMAIL \
--role projects/$PROJECT/roles/gke_deployer

# Download a JSON Service Account key for your newly created service account
gcloud iam service-accounts keys create ./$SA-jenkins-gke-key.json --iam-account $SA_EMAIL


#--- GKE Cluster RBAC Permissions ---
# Create the custom robot-deployer cluster role defined within rbac/robot-deployer.yaml
curl https://raw.githubusercontent.com/jenkinsci/google-kubernetes-engine-plugin/develop/docs/rbac/robot-deployer.yaml >> rbac/robot-deployer.yaml
kubectl create -f rbac/robot-deployer.yaml

# Grant your GCP service account the robot-deployer role binding using rbac/robot-deployer-bindings.yaml:
curl https://raw.githubusercontent.com/jenkinsci/google-kubernetes-engine-plugin/develop/docs/rbac/robot-deployer-bindings.yaml >> rbac/robot-deployer-bindings.yaml
envsubst < rbac/robot-deployer-bindings.yaml | kubectl create -f -

# Clean up
rm -r rbac
