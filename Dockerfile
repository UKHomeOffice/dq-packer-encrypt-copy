FROM hashicorp/packer:light

RUN apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       py3-pip\
       git \
       openssh
# Create and activate virtual environment, then install pipx, awscli & setuptools
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install pipx awscli setuptools \
    && rm -rf /var/cache/apk /root/.cache

RUN adduser -D packer

USER packer
WORKDIR /home/packer

COPY packer*.json ./
COPY build.sh ./
COPY scripts scripts/

ENTRYPOINT
CMD ./build.sh
