#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up pret" | tee -a "$log_file"
git clone --depth 1 "https://github.com/RUB-NDS/PRET" "$path_to_tools/PRET"
cp pret ~/.local/bin/
chmod +x ~/.local/bin/pret
echo "[DONE] Setting up pret" | tee -a "$log_file"
