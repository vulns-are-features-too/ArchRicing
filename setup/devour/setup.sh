#!/bin/bash

set -e
source ../../var.sh

cd "$path_to_tools"
git clone --depth 1 "https://github.com/vulns-are-features-too/devour"
cd devour
sudo make install
