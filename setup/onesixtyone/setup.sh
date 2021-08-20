#!/bin/bash

set -e
source ../../var.sh

cd "$path_to_tools/onesixtyone"
make
cp onesixtyone ~/.local/bin/
