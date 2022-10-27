#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up radare2" | tee -a "$log_file"
r2pm init
r2pm -i $(cat ./plugins | tr '\n' ' ') || echo "Failed to install plugins"
echo "[DONE] Setting up radare2" | tee -a "$log_file"
