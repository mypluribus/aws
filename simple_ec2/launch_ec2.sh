#!/bin/bash

##
## Example: launching an instance w/ AWS CLI
##

AMI='ami-aabbccdd'
COUNT=1
TYPE='t2.micro'
KEY='example-key'
SG='sg-aabbccdd'
SUBNET='subnet-aabbccdd'
MONITORING='True'
PRIV_IP='10.11.12.13'


##
## IAM policy data
##
IAM_PROFILE_NAME='ec2-list-profile'
IAM_ROLE_NAME='ec2-list-only'
IAM_TRUST_POLICY='ec2-trust-policy.json'
IAM_POLICY_NAME='ec2-list-policy'
IAM_ACCESS_POLICY='ec2-access-policy.json'
IAM_INSTANCE_PROFILE_NAME='ec2-list-profile'
IAM_ROLE_NAME='ec2-list-role'

#ACCT_NUM='112233445566'
#IAM_PROFILE_ARN='arn:aws:iam::$ACCT_NUM:instance-profile/$IAM_PROFILE_NAME'


##
## create the IAM role to attach to the instance
##

aws iam create-role \
	--role-name $IAM_ROLE_NAME \
	--assume-role-policy-document file://$IAM_TRUST_POLICY


##
## attach a role to the trust policy
##

aws iam put-role-policy \
	--role-name $IAM_ROLE_NAME \
	--policy-name $IAM_POLICY_NAME \
	--policy-document file://$IAM_ACCESS_POLICY

##
## craete a new instance profile 
##

aws iam create-instance-profile \
	--instance-profile-name $IAM_INSTANCE_PROFILE_NAME


##
## add the access policy to the instance role
##

aws iam add-role-to-instance-profile \
	--instance-profile-name $IAM_INSTANCE_PROFILE_NAME \
	--role-name $IAM_ROLE_NAME


##
## launch ec2 instance
##

aws ec2 run-instances \
	--image-id $AMI \
	--count $COUNT \
	--instance-type $TYPE \
	--key-name $KEY \
	--security-group-id $SG \
	--subnet-id $SUBNET \
	--monitoring Enabled=$MONITORING \
	--private-ip-address $PRIV_IP \
	--iam-instance-profile Name=$IAM_INSTANCE_PROFILE_NAME
#	--iam-instance-profile Arn=$IAM_PROFILE_ARN,Name=$IAM_PROFILE_NAME
