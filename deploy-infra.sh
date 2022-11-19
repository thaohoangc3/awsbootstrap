#!/bin/bash

STACK_NAME=awsbootstrap
REGION=ap-southeast-1
CLI_PROFILE=awsbootstrap

EC2_INSTANCE_TYPE=t2.micro
AWS_ACCOUNT_ID=`aws sts get-caller-identity --profile $CLI_PROFILE --query Account --output text`
CODEPIPELINE_BUCKET=$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID

# Deploy static resources
echo -e "\n\n=================Deploying static resources=================\n\n"

aws cloudformation deploy \
    --template-file setup.yml \
    --stack-name $STACK_NAME-setup \
    --capabilities CAPABILITY_NAMED_IAM \
    --no-fail-on-empty-changeset \
    --region $REGION \
    --profile $CLI_PROFILE \
    --parameter-overrides \
        CodePipelineBucket=$CODEPIPELINE_BUCKET


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
