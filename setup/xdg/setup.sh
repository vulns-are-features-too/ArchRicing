#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up XDG" | tee -a "$log_file"

unset BROWSER
xdg-settings set default-web-browser firefox.desktop

echo "[DONE] Setting up XDG" | tee -a "$log_file"
