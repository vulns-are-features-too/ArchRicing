#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up lxd" | tee -a "$log_file"
sudo usermod -aG lxd $USER
echo "[DONE] Setting up lxd" | tee -a "$log_file"
