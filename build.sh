#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID=${aws_id}
export AWS_SECRET_ACCESS_KEY=${aws_key}

echo "AWS_ACCESS_KEY_ID set"
echo "AWS_SECRET_ACCESS_KEY set"
echo "region = ${region}"

$(aws ec2 describe-images --region ${region} ${filters} --query 'Images[*].[CreationDate, ImageId, Name]' --output text | sort -k1 | tail -n1 >/tmp/build)

echo "Called ec3 describe-images"

$(aws sts get-caller-identity --region ${region} --output text > /tmp/build-account)

echo "Called sts get-caller-identity"

export created=$(cat /tmp/build | awk  -F "\t" '{{print $1}}')
export ami_id=$(cat /tmp/build | awk  -F "\t" '{{print $2}}')
export ami_name=$(cat /tmp/build | awk  -F "\t" '{{print $3}}')
export account=$(cat /tmp/build-account | awk -F "\t" '{{print $1}}')

echo "Found: ${ami_id} - \<${ami_name}\> created ${created} will now make an encrypted copy to this account: ${account}"

packer build packer.json
