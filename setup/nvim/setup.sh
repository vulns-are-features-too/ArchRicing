#!/bin/bash

set -e
source ../../var.sh

echo -e "[START] Installing and setting up stuff for nvim" | tee -a "$log_file"

# Get nvim nightly
wget 'https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage'
mv nvim.appimage ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim

# Install packer
# git clone --depth 1 https://github.com/wbthomason/packer.nvim\
#   ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# sym-link vim to nvim
# ln -sf ~/.local/bin/nvim ~/.local/bin/vim

echo -e "[DONE] Installing and setting up stuff for nvim" | tee -a "$log_file"
