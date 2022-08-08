#!/bin/bash

###################################################################
#Script Name	:calculator-perfromance-test.sh
#Description	:Test calculator service 100 times
#		:Fail if average response time is over 1 second
#Args           :
#Author       	:Luke Gregory
#Email         	:lukewgregory@gmail.com
#Date		:5/8/2022
###################################################################

NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
NODE_PORT=$(kubectl get svc calculator-service -o jsonpath='{.spec.ports[0].nodePort}')
TEST_COMMAND="curl http://$NODE_IP:$NODE_PORT/sum?a=2\&b=3"

./performance-test.sh "$TEST_COMMAND" 100 1
