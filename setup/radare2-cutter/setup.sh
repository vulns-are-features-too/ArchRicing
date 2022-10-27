#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up radare2-cutter" | tee -a "$log_file"
mkdir $path_to_tools/radare2-cutter || echo "$path_to_tools/radare2-cutter already exists"
wget https://github.com/$(curl -s https://github.com/radareorg/cutter/releases\#downloads | grep AppImage | head -1 | cut -d '"' -f 2) -O Cutter.AppImage
chmod +x Cutter.AppImage
mv Cutter.AppImage $path_to_tools/radare2-cutter
echo "[DONE] Setting up radare2-cutter" | tee -a "$log_file"
