#!/usr/bin/env bash

echo "filters = ${filters}"
echo "aws_id = ${aws_id}"
echo "AWS_ACCESS_KEY_ID = ${AWS_ACCESS_KEY_ID}"
echo "region = ${region}"
echo "AWS_DEFAULT_REGION = ${AWS_DEFAULT_REGION}"


export AWS_ACCESS_KEY_ID=${aws_id}
export AWS_SECRET_ACCESS_KEY=${aws_key}

echo "aws_id = ${aws_id}"
echo "AWS_ACCESS_KEY_ID = ${AWS_ACCESS_KEY_ID}"

echo "AWS_SECRET_ACCESS_KEY set"

$(aws ec2 describe-images --region ${region} ${filters} --query 'Images[*].[CreationDate, ImageId, Name]' --output text | sort -k1 | tail -n1 > /tmp/build)

echo "Called ec3 describe-images"

$(aws sts get-caller-identity --region ${region} --output text > /tmp/build-account)

echo "Called sts get-caller-identity"

export region="eu-west-2"
echo "region = ${region}"

$(aws ec2 describe-images --region ${region} ${filters} --query 'Images[*].[CreationDate, ImageId, Name]' --output text | sort -k1 | tail -n1 > /tmp/build_2)

echo "Called ec3 describe-images"

$(aws sts get-caller-identity --region ${region} --output text > /tmp/build-account_2)

echo "Called sts get-caller-identity"

export created=$(cat /tmp/build | awk  -F "\t" '{{print $1}}')
export ami_id=$(cat /tmp/build | awk  -F "\t" '{{print $2}}')
export ami_name=$(cat /tmp/build | awk  -F "\t" '{{print $3}}')
export account=$(cat /tmp/build-account | awk -F "\t" '{{print $1}}')

echo "Found: ${ami_id} - \<${ami_name}\> created ${created} will now make an encrypted copy to this account: ${account}"

packer build packer.json
