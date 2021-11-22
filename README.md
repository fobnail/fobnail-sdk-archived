# fobnail-sdk

Dockerized fobnail software development kit

## Using Rust container

Rust container is the newer version of SDK, to build it execute:

```shell
./build.sh
```

To build a sample Rust application execute:

```shell
$ git clone https://github.com/fobnail/nrf-hal
$ cd nrf-hal
$ git checkout blinky-demo-nrf52840
$ ./run-container.sh
(docker)$ cd examples/blinky-demo-nrf52840
(docker)$ cargo build --target=thumbv7em-none-eabihf
```

## Using Zephyr container

To build the container execute:

```shell
./build-zephyr.sh
```

The script will source tools version from [tools-versions file](tools-versions).

```shell
git clone https://github.com/zephyrproject-rtos/zephyr.git -b v2.6.0
./run-zephyr.sh
```

The [run-zephyr.sh script](run-zephyr.sh) will mount the zephyr directory inside
the container automatically and initialize Zephyr for work. To build a sample
application for mcuboot inside the container:

```shell
west build -b nrf52840dongle_nrf52840 -d build/blinky \
	 samples/basic/blinky -- -DCONFIG_BOOTLOADER_MCUBOOT=y
```
