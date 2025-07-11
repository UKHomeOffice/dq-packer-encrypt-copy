#!/usr/bin/env bash

echo "region = ${region}"
echo "filters = ${filters}"
echo "os = ${os}"

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


packer --version
if [ "${os}" == 'win2012' ]; then
    packer_file="packer-ec2config.json"
elif [ "${os}" == 'win2019' ]; then
    packer_file="packer-winrm-ec2launch-v2.json"
elif [ "${os}" == 'linux' ]; then
    packer_file="packer.json"
else
  packer_file="packer.json"
fi

echo "Installing required plugins before build"

packer plugins install github.com/hashicorp/amazon

packer build ${packer_file}

./copy-ami-to-prod.sh "${ami_id}" "337779336338" "${region}"
