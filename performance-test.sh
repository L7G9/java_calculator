#!/bin/bash

###################################################################
#Script Name	:perfromance-test.sh
#Description	:A harness to run a simple performace test
#Arg 1          :Command to test
#Arg 2		:Number of times to call command
#Arg 3		:Average time in seconds command must be completed in
#Author       	:Luke Gregory
#Email         	:lukewgregory@gmail.com
#Date		:5/8/2022
###################################################################

TEST_COMMAND=$1 # command to test
CALLS=$2 # number of times to call calculator service
MAX_AVERAGE_TIME=$3 # max average time in seconds os each call for test to pass
MAX_DURATION="$((CALLS*MAX_AVERAGE_TIME))" # max total duration in seconds test can take to pass

#run tests
start_time=$(date +%s)
for((i=0;i<CALLS;i++));do
	eval "$TEST_COMMAND"
done
end_time=$(date +%s)

#check for failure
duration="$((end_time-start_time))"
if((duration>MAX_DURATION)); then
    exit 1
fi
