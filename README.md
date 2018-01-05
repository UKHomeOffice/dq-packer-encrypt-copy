# Packer encrypt copy

This will be useful if
- You can't copy images that are public (aws limitation)
- You can't copy images between accounts that are encrypted (aws limitation)
- You don't mind your origin image being open
- 


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