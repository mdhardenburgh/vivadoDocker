# Copyright 2024 Matthew Hardenburgh

# $docker build .

# use latest ubuntu image
FROM ubuntu:24.04

# install C++ tool chain
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential

# install gdb
RUN apt-get install -y gdb

# install cmake

# install vivado
COPY FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001.tar .
RUN tar -zxf Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz
RUN FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config installation_config.txt