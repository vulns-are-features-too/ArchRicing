#!/bin/bash

systemd-detect-virt -q && exit

source ../../var.sh

cd $path_to_tools
git clone https://github.com/mwh/dragon
cd dragon
make
make install
cd  $path_current
