#!/usr/bin/bash

# Install 2 "versions" of pwncat
# https://github.com/calebstewart/pwncat - Pwncat
# https://github.com/cytopia/pwncat - pwncat

set -e
source ../../var.sh

pip install git+https://github.com/calebstewart/pwncat.git
mv ~/.local/bin/pwncat ~/.local/bin/Pwncat

sudo pacman -S pwncat
