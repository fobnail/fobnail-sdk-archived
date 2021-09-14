FROM ubuntu:20.04
MAINTAINER Piotr Król <piotr.krol@3mdeb.com>

RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    git \
    cmake \
    ninja-build \
    gperf \
    ccache \
    curl \
    dfu-util \
    device-tree-compiler \
    wget \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    xz-utils \
    file \
    make \
    gcc \
    gcc-multilib \
    locales \
    libtool \
    autotools-dev \
    automake \
    autoconf \
    m4 \
    python \
    python-dev \
    python-setuptools \
    python-pip-whl \
    nano \
    udev \
    unzip

RUN locale-gen en_US && locale-gen en_US.UTF-8
RUN update-locale

# python-dev is needed for libpython2.7.so.1.0 which is required for debugger
RUN pip3 install --upgrade setuptools pip
RUN pip3 install west

# OT FOTA Package generation and EEPROM parameters metadata generation
RUN pip3 install nrfutil cogapp

RUN pip3 install cryptography intelhex click

# install zephyr requirements
RUN pip3 install -r https://raw.githubusercontent.com/zephyrproject-rtos/zephyr/{{ZEPHYR_VER}}/scripts/requirements.txt

RUN wget --progress=bar:force:noscroll \
    https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v{{ZEPHYR_SDK_VER}}/zephyr-sdk-{{ZEPHYR_SDK_VER}}-linux-x86_64-setup.run \
    -O /tmp/zephyr-sdk-{{ZEPHYR_SDK_VER}}-linux-x86_64-setup.run && \
    chmod +x /tmp/zephyr-sdk-{{ZEPHYR_SDK_VER}}-linux-x86_64-setup.run && \
    /tmp/zephyr-sdk-{{ZEPHYR_SDK_VER}}-linux-x86_64-setup.run -- -d /opt/zephyr-sdk/ && \
    rm /tmp/zephyr-sdk-{{ZEPHYR_SDK_VER}}-linux-x86_64-setup.run

RUN curl https://www.segger.com/downloads/jlink/JLink_Linux_{{SEGGER_JLINK_VER}}_x86_64.deb \
    --data 'accept_license_agreement=accepted&submit=Download+software' \
    --output /tmp/JLink_Linux_{{SEGGER_JLINK_VER}}_x86_64.deb && \
    dpkg -i /tmp/JLink_Linux_{{SEGGER_JLINK_VER}}_x86_64.deb && \
    rm /tmp/JLink_Linux_{{SEGGER_JLINK_VER}}_x86_64.deb

RUN curl https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-{{NRF_VERSION_MAJOR}}-x-x/{{NRF_CMDLINE_VER_DASH}}/nRF-Command-Line-Tools_{{NRF_CMDLINE_VER}}_Linux64.zip \
    --output /tmp/nRF-Command-Line-Tools_{{NRF_CMDLINE_VER}}_Linux-x86_64.zip && \
    unzip -j /tmp/nRF-Command-Line-Tools_{{NRF_CMDLINE_VER}}_Linux-x86_64.zip -d /tmp/nrftools && \
    rm /tmp/nRF-Command-Line-Tools_{{NRF_CMDLINE_VER}}_Linux-x86_64.zip && cd /tmp/nrftools && \
    dpkg -i nrf-command-line-tools_{{NRF_CMDLINE_VER_DOTS}}_amd64.deb && rm -rf /tmp/nrftools

RUN useradd -ms /bin/bash build && \
    usermod -aG sudo build

USER build

WORKDIR /home/build

WORKDIR /home/build/zephyr

ENV PATH="/opt/nrf-command-line-tools/bin${PATH}"
ENV LC_ALL en_US.UTF-8
ENV ZEPHYR_TOOLCHAIN_VARIANT zephyr
ENV ZEPHYR_SDK_INSTALL_DIR /opt/zephyr-sdk
ENV ZEPHYR_BASE /home/build/zephyr

# We run west init and update on entrypoint because we work on user-supplied 
# zephyr directory. It is now known on docker compilation time...
ENTRYPOINT west init -l /home/build/zephyr && west update; /bin/bash
