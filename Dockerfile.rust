FROM rust:1.55.0-slim-buster

RUN apt-get update && apt-get install -y \
    libusb-1.0-0-dev \
    libftdi1-dev \
    pkg-config \
    && \
    rm -rf /var/lib/apt/lists/*

RUN rustup target add thumbv7em-none-eabihf

RUN cargo install cargo-embed && cargo install probe-rs-cli

RUN useradd -ms /bin/bash build && \
    usermod -aG sudo,dialout build && \
    echo 'export CARGO_HOME=~/.cargo' >> /home/build/.bashrc

USER build
WORKDIR /home/build
