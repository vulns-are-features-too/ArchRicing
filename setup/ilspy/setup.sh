#!/bin/bash

[ "$(systemd-detect-virt)" == "none" ] || exit

set -e
source ../../var.sh

cd "$path_to_tools"
git clone --depth 1 "https://github.com/icsharpcode/ILSpy"
cd ILSpy
git submodule update --init --recursive
dotnet build Frontends.sln
