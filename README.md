#Packer encrypt copy

##usage:

```bash
docker run \
  -e region=eu-west-2 \
  -e AWS_ACCESS_KEY_ID=... \
  -e AWS_SECRET_ACCESS_KEY=... \
  -e filters="--owner 093401982388 --filters "Name=name,Values=something*"" \
  -e 
  chrisns/packer-encrypt-copy
```