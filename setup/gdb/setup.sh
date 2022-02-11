#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up gdb" | tee -a "$log_file"
path_to_peda="$path_to_tools/peda"
git clone https://github.com/longld/peda.git $path_to_peda
echo "[DONE] Setting up gdb" | tee -a "$log_file"
