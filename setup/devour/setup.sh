#!/bin/bash

set -e
source ../../var.sh

cd "$path_to_tools"
git clone --depth 1 "https://github.com/ChocolateOverflow/devour"
cd devour
sudo make install
