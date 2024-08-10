FROM alpine:3.20.2

LABEL net.juniper.description="Junos PyEZ library for Python in a lightweight container." \
      net.juniper.maintainer="jnpr-community-netdev@juniper.net"

WORKDIR /source

## Copy project inside the container
ADD setup.* ./
ADD versioneer.py .
ADD requirements.txt .
ADD lib lib 
ADD entrypoint.sh /usr/local/bin/.

## Install dependencies
RUN apk add --no-cache build-base python3-dev \
    libxslt-dev libxml2-dev libffi-dev openssl-dev curl \
    ca-certificates py3-pip bash

## Update as per PEP 668. Use Virtual Env
RUN python3 -m venv /scripts/.venv \
    && source /scripts/.venv/bin/activate \
    && pip install --upgrade pip \
    && pip install pipdeptree \
    && python3 -m pip install -r requirements.txt \
    && pip install .

## Clean up and start init
RUN apk del -r --purge gcc make g++ \
    && rm -rf /source/* \
    && chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /scripts

VOLUME /scripts

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
