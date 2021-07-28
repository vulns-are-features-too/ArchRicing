#!/bin/bash

set -e
source ../../var.sh

systemd-detect-virt || git clone --depth 1 https://github.com/trailofbits/onesixtyone "$path_to_tools/onesixtyone"
cd "$path_to_tools/onesixtyone"
systemd-detect-virt || make
cp onesixtyone ~/.local/bin/
