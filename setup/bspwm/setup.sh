#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up bspwm" | tee -a "$log_file"
chmod +x $HOME/.config/bspwm/bspwmrc
echo "[DONE] Setting up bspwm" | tee -a "$log_file"
