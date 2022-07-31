#!/bin/bash
set -x

NODE_PORT=$(kubectl get svc calculator-service -o jsonpath='{.spec.ports[0].nodePort}')
gcloud compute firewall-rules create test-node-port --allow tcp:${NODE_PORT}
