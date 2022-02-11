#!/usr/bin/bash

set -e
source ../../var.sh

echo -e "[START] Installing and setting up stuff for nvim" | tee -a "$log_file"

# Get nvim nightly
wget 'https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage'
mv nvim.appimage ~/.local/bin/nvim
chmod +x ~/.local/bin/nvim

mkdir -p $path_to_vim/autoload $path_to_vim/plugged

# Install stuff with package manager
sudo pacman -S --needed --noconfirm vim-runtime

# Install vim-plug
curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > $path_to_vim/autoload/plug.vim

# Install all the plugins
~/.local/bin/nvim --cmd ":source $path_to_vim/init.vim" \
	-c ":PlugInstall" \
	-c ":qa!" 2>/dev/null

# tree-sitter, Vimspector
~/.local/bin/nvim --cmd ":source $path_to_vim/init.vim" \
    -c ":TSInstall bash c cpp html java javascript json php python regex rust"
	-c ":qa!" 2>/dev/null

# sym-link vim to nvim
ln -sf ~/.local/bin/nvim ~/.local/bin/vim

echo -e "[DONE] Installing and setting up stuff for nvim" | tee -a "$log_file"
