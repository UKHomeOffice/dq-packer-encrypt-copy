# Packer encrypt copy

## This will be useful if:
- You can't copy images that are public (aws limitation)
- You can't copy images between accounts that are encrypted (aws limitation)
- You don't mind your origin image being unencrypted
- You want your running images with your actual data to be encrypted
- You maybe have pay as you go licences RHEL or Windows that would be lost through other means (you can't specify the billing code yourself if you share/copy snapshots)

## What happens:
- packer brings up an ec2 instance with the AMI in the destination account
- packer makes an unencrypted AMI from that
- packer makes an encrypted copy from that AMI
- packer destroys the unencrypted AMI
- new AMI in the destination account with a name like something copied from ami-xxxxx so you can follow it back

## Things to be aware of / downsides:
- There is a chance that when packer starts the image, something happens that won't happen on subsequent boots or changes things (cloud-init maybe?) and you'll end up imaging an 'unsealed' image.

## Vulnerabilities
We base our "encrypt-copy" image on Hashicorp's latest "Packer" Docker image. <br>
However, their image is not updated very frequently (at time of writing it is 3 months old)
therefore vulnerabilities will creep in. <br>
We attempt to fix these by updating and upgrading the Alpine packages. <br>
However, some (e.g. golang) do not appear to be resolvable so they are added to the `.trivyignore` file. <br>
These counter-measures (added packages and ignorefile) should be revisited every month 
when our routine vulnerability process is run.

## Usage:

### Docker
```bash
docker run \
  --rm \
  -e region=eu-west-2 \
  -e aws_id=... \
  -e aws_key=... \
  -e filters="--owner 000000 --filters "Name=name,Values=something*"" \
  -e os="<OS TO BE COPIED>"
  UKHomeOffice/dq-packer-encrypt-copy
```

### Drone
```yaml
  packer-copy-notprod:
    image: UKHomeOffice/dq-packer-encrypt-copy
    commands:
      - export region=eu-west-2
      - export aws_id=$${NOTPROD_ACC_ID}
      - export aws_key=$${NOTPROD_ACC_KEY}
      - export filters="--owner 000000 --filters "Name=name,Values=something*""
      - export os="<OS TO BE COPIED>"
      - ./build.sh
    secrets:
        - NOTPROD_ACC_ID
        - NOTPROD_ACC_KEY
    when:
      event: push
      branch: master
```

## Improvements
- [ ] allow `instance_type` to be configurable
- [ ] skip temp ssh key pair creation
- [ ] skip temp security group creation
- [ ] test with windows
