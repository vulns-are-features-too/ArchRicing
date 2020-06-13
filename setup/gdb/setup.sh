#!/usr/bin/sh

set -e
source var.sh

# Install peda
path_to_peda="$path_to_pentest/peda"
git clone https://github.com/longld/peda.git $path_to_peda
echo "source $path_to_peda/peda.py" >> ~/.gdbinit
