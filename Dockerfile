# Copyright 2024 Matthew Hardenburgh

# $docker build .

# use latest ubuntu image
FROM ubuntu:24.04

# install gcc tool chain
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential

# install gdb
RUN apt-get install -y gdb

# install cmake

# install google cloud CLI and pull down vivado tarball to CWD
# NOTE: Skip this step if downloaded from xilinx/AMD website

# install vivado
COPY FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001.tar .
COPY install_config.txt .
RUN tar -xvf FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001.tar
RUN FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001/xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config install_config.txt