#!/usr/bin/env bash

echo "==> Sharing AMI to this account (target: ${aws_id})"
echo "region = ${region}"
echo "filters = ${filters}"

export AWS_ACCESS_KEY_ID=${aws_id}
export AWS_SECRET_ACCESS_KEY=${aws_key}

# Get latest AMI info
aws ec2 describe-images --region "${region}" ${filters} \
  --query 'Images[*].[CreationDate,ImageId,Name]' \
  --output text | sort -k1 | tail -n1 > /tmp/build

created=$(awk -F "\t" '{print $1}' /tmp/build)
source_ami_id=$(awk -F "\t" '{print $2}' /tmp/build)
source_ami_name=$(awk -F "\t" '{print $3}' /tmp/build)

echo "Found source AMI: ID=${source_ami_id}, Name=${source_ami_name}, Created=${created}"

# Copy the AMI to the target account (this account)
copy_ami_id=$(aws ec2 copy-image \
  --region "${region}" \
  --source-region "${region}" \
  --source-image-id "${source_ami_id}" \
  --name "${source_ami_name}-copy-to-prod-$(date +%Y%m%d%H%M%S)" \
  --encrypted \
  --output text)

echo "Started AMI copy. New AMI ID: ${copy_ami_id}"

# Optional wait
echo "Waiting for copied AMI (${copy_ami_id}) to become available..."
aws ec2 wait image-available --region "${region}" --image-ids "${copy_ami_id}"
echo "AMI copy is now available."