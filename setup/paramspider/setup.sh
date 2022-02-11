#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up paramspider" | tee -a "$log_file"
cd "$path_to_tools"
git clone --depth 1 "https://github.com/devanshbatham/ParamSpider"
ln -sf "$path_to_tools/ParamSpider/paramspider.py" ~/.local/bin/paramspider
echo "[DONE] Setting up paramspider" | tee -a "$log_file"
