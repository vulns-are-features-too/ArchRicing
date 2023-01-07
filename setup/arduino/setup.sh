#!/bin/bash

systemd-detect-virt -q && exit
set -e
source ../../var.sh

echo "[START] Setting up arduino" | tee -a "$log_file"
arduino-cli core install arduino:avr arduino:megaavr
sudo usermod -aG uucp "$USER"
echo "[DONE] Setting up arduino" | tee -a "$log_file"
