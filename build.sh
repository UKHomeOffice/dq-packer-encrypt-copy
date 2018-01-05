#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID=${aws_id}
export AWS_SECRET_ACCESS_KEY=${aws_key}

$(aws ec2 describe-images --region ${region} ${filters} --query 'Images[*].[CreationDate, ImageId, Name]' --output text | sort -k1 | tail -n1 >/tmp/build)

export created=$(cat /tmp/build | awk  -F "\t" '{{print $1}}')
export ami_id=$(cat /tmp/build | awk  -F "\t" '{{print $2}}')
export ami_name=$(cat /tmp/build | awk  -F "\t" '{{print $3}}')

echo Found: ${ami_id} -  \<${ami_name}\> created ${created} will now make an encrypted copy of this into: ${region}

packer build packer.json
