#!/bin/bash

[ "$(systemd-detect-virt)" == "none" ] || exit

set -e
source ../../var.sh

# Install peda
path_to_peda="$path_to_tools/peda"
git clone https://github.com/longld/peda.git $path_to_peda
#echo "source $path_to_peda/peda.py" >> ~/.gdbinit
