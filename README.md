# Packer encrypt copy

## This will be useful if:
- You can't copy images that are public (aws limitation)
- You can't copy images between accounts that are encrypted (aws limitation)
- You don't mind your origin image being unencrypted
- You want your running images with your actual data to be encrypted

## What happens:
- packer brings up an ec2 instance with the AMI in the destination account
- packer makes an unencrypted AMI from that
- packer makes an encrypted copy from that AMI
- packer destroys the unencrypted AMI

## Usage:

### Docker
```bash
docker run \
  -e region=eu-west-2 \
  -e aws_id=... \
  -e aws_key=... \
  -e filters="--owner 000000 --filters "Name=name,Values=something*"" \
  -e 
  chrisns/packer-encrypt-copy
```

### Drone
```yaml
  packer-copy-mocks:
    image: chrisns/packer-encrypt-copy
    pull: true
    commands:
      - export region=eu-west-2
      - export filters="--owner 000000 --filters "Name=name,Values=something*""
      - export aws_id=${notprod_id}
      - export aws_key=${notprod_key}
      - ./build.sh
    when:
      event: push
      branch: master
```

## Improvements
- [ ] allow `instance_type` to be configurable
- [ ] skip temp ssh key pair creation
- [ ] skip temp security group creation