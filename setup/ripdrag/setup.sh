#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up ripdrag" | tee -a "$log_file"
sudo pacman -S --needed gtk4
cargo install ripdrag
echo "[DONE] Setting up ripdrag" | tee -a "$log_file"
