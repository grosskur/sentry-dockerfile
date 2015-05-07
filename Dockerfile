FROM ubuntu:14.04
MAINTAINER Alan Grosskurth <code@alan.grosskurth.ca>

RUN \
  locale-gen en_US.UTF-8 && \
  apt-get update && \
  env DEBIAN_FRONTEND=noninteractive apt-get -q -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    libffi-dev \
    libmemcached-dev \
    libncurses5-dev \
    libpq-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    pkg-config \
    zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV HOME=/app

RUN \
  mkdir -p /tmp/src /app/.local/python /app/.local/node && \
  cd /tmp/src && \
  curl -fsLS -O https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz && \
  curl -fsLS -O https://bootstrap.pypa.io/get-pip.py && \
  echo '90d27e14ea7e03570026850e2e50ba71ad20b7eb31035aada1cf3def8f8d4916  Python-2.7.9.tar.xz' | sha256sum -c && \
  tar -xJf Python-2.7.9.tar.xz && \
  cd /tmp/src/Python-2.7.9 && \
  env LDFLAGS='-Wl,-rpath=/app/.local/python/lib' \
    ./configure --enable-shared --prefix=/app/.local/python && \
  make && \
  make install && \
  ldconfig && \
  cd /tmp/src && \
  /app/.local/python/bin/python get-pip.py && \
  cd /tmp && \
  rm -rf /tmp/src

WORKDIR /app
ENV PATH=/app/.local/python/bin:$PATH PYTHONPATH=/app

COPY requirements.txt /app/requirements.txt
RUN /app/.local/python/bin/pip install -r requirements.txt

USER nobody
EXPOSE 9000

ENTRYPOINT []
CMD []
