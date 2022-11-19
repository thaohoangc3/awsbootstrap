#!/bin/bash

STACK_NAME=awsbootstrap
REGION=ap-southeast-1
CLI_PROFILE=awsbootstrap

EC2_INSTANCE_TYPE=t2.micro

# Deploy the CloudFormation template

echo -e "\n\n=========Deploying main.yml==========="

aws cloudformation deploy \
    --template-file main.yml \
    --stack-name $STACK_NAME \
    --region $REGION \
    --profile $CLI_PROFILE \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        EC2InstanceType=$EC2_INSTANCE_TYPE

if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile awsbootstrap \
    --query "Exports[?Name=='InstanceEndpoint'].Value"
fi
