#!/bin/bash

systemd-detect-virt -q && exit

set -e
source ../../var.sh

git clone --depth 1 "https://github.com/RUB-NDS/PRET" "$path_to_tools/PRET"
cp pret ~/.local/bin/
chmod +x ~/.local/bin/pret
