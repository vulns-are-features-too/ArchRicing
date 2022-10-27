#!/bin/bash

set -e
source ../../var.sh

echo -e "[START] Installing bat-extras" | tee -a "$log_file"

cd "$path_to_tools"
git clone --depth 1 "https://github.com/eth-p/bat-extras"
cd bat-extras
sudo ./build.sh --install

echo -e "[DONE] Installing bat-extras" | tee -a "$log_file"
