# fobnail-sdk

Dockerized fobnail software development kit

## Build

To build the container execute:

```shell
./build.sh
```

The script will source tools version from [tools-versions file](tools-versions).

## Usage

```shell
git clone https://github.com/zephyrproject-rtos/zephyr.git -b v2.6.0
./run.sh
```

The [run.sh script](run.sh) will mount the zephyr directory inside the
container automatically and initialize Zephyr for work. To build a sample
application for mcuboot inside the container:

```shell
west build -b nrf52840dongle_nrf52840 -d build/blinky \
	 samples/basic/blinky -- -DCONFIG_BOOTLOADER_MCUBOOT=y
```
