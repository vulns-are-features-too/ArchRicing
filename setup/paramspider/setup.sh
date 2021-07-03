#!/bin/bash

set -e
source ../../var.sh

cd "$path_to_tools"
git clone --depth 1 "https://github.com/devanshbatham/ParamSpider"
ln -sf "$path_to_tools/ParamSpider/paramspider.py" ~/.local/bin/paramspider
