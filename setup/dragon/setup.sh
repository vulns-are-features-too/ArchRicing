#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up dragon" | tee -a "$log_file"
cd $path_to_tools
git clone https://github.com/mwh/dragon
cd dragon
make
make install
cd  $path_current
echo "[DONE] Setting up dragon" | tee -a "$log_file"
