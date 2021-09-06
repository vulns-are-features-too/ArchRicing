#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up onesixtyone" | tee -a "$log_file"
cd "$path_to_tools/onesixtyone"
make
cp onesixtyone ~/.local/bin/
echo "[DONE] Setting up onesixtyone" | tee -a "$log_file"
