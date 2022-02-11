#!/bin/bash
source ../../var.sh

echo "[START] Setting up mount" | tee -a "$log_file"
sudo groupadd mount
sudo usermod -aG mount $USER
echo "[DONE] Setting up mount" | tee -a "$log_file"
