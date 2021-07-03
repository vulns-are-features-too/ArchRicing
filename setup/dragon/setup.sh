#!/bin/bash

[ "$(systemd-detect-virt)" == "none" ] || exit

source ../../var.sh

cd $path_to_tools
git clone https://github.com/mwh/dragon
cd dragon
make
make install
cd  $path_current
