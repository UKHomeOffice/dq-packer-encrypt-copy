FROM hashicorp/packer:light

RUN apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       py3-pip\
       git \
       openssh \
       aws-cli \
    && apk del gnupg gnupg-dirmngr gnupg-gpgconf gnupg-keyboxd gnupg-utils \
              gnupg-wks-client gpg gpg-agent gpg-wks-server gpgsm gpgv || true 
    # && pip install --no-cache-dir --upgrade pip setuptools \
    # && pip install --no-cache-dir awscli   

RUN adduser -D packer

USER packer
WORKDIR /home/packer

COPY packer*.json ./
COPY build.sh ./
COPY scripts scripts/

ENTRYPOINT
CMD ./build.sh
