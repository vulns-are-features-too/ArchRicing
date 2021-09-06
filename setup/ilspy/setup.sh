#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up ilspy" | tee -a "$log_file"
cd "$path_to_tools"
git clone --depth 1 "https://github.com/icsharpcode/ILSpy"
cd ILSpy
git submodule update --init --recursive
dotnet build Frontends.sln
echo "[DONE] Setting up ilspy" | tee -a "$log_file"
