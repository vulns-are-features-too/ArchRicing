#!/bin/bash

set -e
source ../../var.sh

type r2pm &>/dev/null || exit
echo "[START] Setting up radare2" | tee -a "$log_file"
r2pm -U
r2pm -i $(tr '\n' ' ' < ./plugins ) || echo "Failed to install plugins"
echo "[DONE] Setting up radare2" | tee -a "$log_file"
