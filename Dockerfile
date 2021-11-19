FROM amd64/ubuntu:latest

ARG BUILDROOT_VERSION=2021.02.7 \
ARG DEFCONFIG=rpi4_64

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8 \
    LC_ALL=en_US.utf8

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gpg-agent \
    gpg \
    dirmngr \
    software-properties-common \
    && \
    rm -rf /var/lib/apt/lists/*

# Build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    cpio \
    file \
    git \
    graphviz \
    make \
    ncurses-dev \
    openssh-client \
    patch \
    perl \
    python-is-python3 \
    python3 \
    python3-matplotlib \
    qemu-utils \
    rsync \
    sudo \
    unzip \
    vim \
    wget \
    zip \
    && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash builder  \
 && mkdir -p /build  \
 && chown -R builder:builder /build

USER builder
WORKDIR /build
ENV HOME=/build

COPY buildroot-external /build/buildroot-external
COPY Makefile /build/Makefile

RUN mkdir -p buildroot; wget -c https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz -O - | tar -xz -C ./buildroot --strip-components 1

RUN make ${DEFCONFIG}