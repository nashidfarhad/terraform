#!/bin/bash
export AWS_ACCESS_KEY_ID=$(grep -A2 dinggo ~/.aws/credentials | tail -n2 | head -n1 | cut -f 2 -d'=' | tr -d [:blank:])
export AWS_SECRET_ACCESS_KEY=$(grep -A2 dinggo ~/.aws/credentials | tail -n1 | cut -f 2 -d'=' | tr -d [:blank:])
export AWS_DEFAULT_REGION="ap-southeast-2"
#export AWS_ACCESS_KEY_ID=$(aws configure get krost.aws_access_key_id)
#export AWS_SECRET_ACCESS_KEY=$(aws configure get krost.aws_secret_access_key)
#export AWS_DEFAULT_REGION=$(aws configure get krost.region)

export WORKSPACE_STAGE=staging
export WORKSPACE_PROD=production
export AWS_ACCOUNT_ID=665411276415
