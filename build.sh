#!/usr/bin/env bash

echo "region = ${region}"
echo "filters = ${filters}"

export AWS_ACCESS_KEY_ID=${aws_id}
export AWS_SECRET_ACCESS_KEY=${aws_key}

$(aws ec2 describe-images --region ${region} ${filters} --query 'Images[*].[CreationDate, ImageId, Name]' --output text | sort -k1 | tail -n1 > /tmp/build)

$(aws sts get-caller-identity --output text > /tmp/build-account)


export created=$(cat /tmp/build | awk  -F "\t" '{{print $1}}')
export ami_id=$(cat /tmp/build | awk  -F "\t" '{{print $2}}')
export ami_name=$(cat /tmp/build | awk  -F "\t" '{{print $3}}')
export account=$(cat /tmp/build-account | awk -F "\t" '{{print $1}}')

echo "Found AMI: (ID: <${ami_id}> Name: <${ami_name}> Created: <${created}>)."
echo "Will now make an encrypted copy to account: <${account}>."

packer --version build packer.json
