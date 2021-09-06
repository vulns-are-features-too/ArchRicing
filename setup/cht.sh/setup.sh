#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up cht.sh" | tee -a "$log_file"
curl https://cht.sh/:cht.sh > ~/.local/bin/cht.sh
chmod +x ~/.local/bin/cht.sh
echo "[DONE] Setting up cht.sh" | tee -a "$log_file"
