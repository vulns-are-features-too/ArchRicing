#!/bin/bash

set -e
source ../../var.sh

git clone --depth 1 https://github.com/trailofbits/onesixtyone "$path_to_tools/onesixtyone"
cd "$path_to_tools/onesixtyone"
make
cp onesixtyone ~/.local/bin/
