# Docker USB/Serial Passthrough on macOS to an Ubuntu Container

If you're running an **Ubuntu Docker container on macOS**, normal Linux
USB passthrough such as:

``` bash
docker run --device=/dev/ttyUSB0 ...
```

generally **doesn't work the way it does on a Linux host**. On macOS,
Docker Desktop runs Linux containers inside a Linux VM, so the container
doesn't directly see macOS USB devices.

For a USB serial device---like an FPGA UART/JTAG interface---the easiest
solution is usually to **forward the serial port over TCP** rather than
trying to pass through the USB device itself.

## 1. Find the serial device on macOS

``` bash
ls /dev/cu.*
```

You may get something like:

``` text
/dev/cu.usbserial-XXXXXXXX
```

## 2. Forward the serial port from macOS over TCP

Install `socat`:

``` bash
brew install socat
```

Then forward the serial device:

``` bash
socat TCP-LISTEN:7000,reuseaddr,fork FILE:/dev/cu.usbserial-XXXXXXXX,raw,echo=0,b115200
```

Replace `/dev/cu.usbserial-XXXXXXXX` with the actual device name.

## 3. Start the Ubuntu container

``` bash
docker run -it ubuntu:latest
```

## 4. Create a virtual serial port inside the container

Inside the Ubuntu container:

``` bash
apt update
apt install socat
```

Then:

``` bash
socat PTY,link=/dev/ttyUSB0,raw,echo=0 TCP:host.docker.internal:7000
```

Software inside the Ubuntu container can now use:

``` text
/dev/ttyUSB0
```

almost as though the USB UART were directly attached.

## Actual USB Device Passthrough

If this isn't just UART and you need **USB-level access**---for example,
Vivado needs to communicate with a Digilent FTDI/JTAG interface---serial
forwarding is not enough.

You would need USB/IP or another Docker Desktop USB-forwarding
mechanism. USB passthrough is more complicated on macOS because the
Linux containers are running inside Docker Desktop's Linux VM rather
than directly on the macOS kernel.

For a **Nexys 4 DDR**, this distinction matters because its FT2232
provides interfaces used for UART and JTAG.

-   If the Ubuntu container only needs a serial port for UART
    communication, TCP serial forwarding is a straightforward solution.
-   If you need **Vivado Hardware Manager, OpenOCD, or JTAG** from
    inside Docker, you need actual USB-level passthrough rather than
    serial forwarding.
