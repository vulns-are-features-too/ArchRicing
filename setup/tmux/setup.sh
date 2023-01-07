#!/bin/bash

set -e
source ../../var.sh

echo -e "[START] Installing tmux stuff" | tee -a "$log_file"

mkdir -p ~/.config/tmux/plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

echo -e "[DONE] Installing tmux stuff" | tee -a "$log_file"
