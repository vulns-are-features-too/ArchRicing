#!/usr/bin/bash
source ../../var.sh

echo "[START] Setting up wireshark" | tee -a "$log_file"
sudo usermod -a -G wireshark $USER
echo "[DONE] Setting up wireshark" | tee -a "$log_file"
