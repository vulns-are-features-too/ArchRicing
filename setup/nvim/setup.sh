#!/usr/bin/bash

set -e
source ../../var.sh

echo -e "[START] Installing and setting up stuff for Vim\n"

mkdir -p $path_to_vim/autoload $path_to_vim/plugged

# Install stuff with package manager
sudo pacman -S --needed --noconfirm vim-runtime

# Install vim-plug
curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > $path_to_vim/autoload/plug.vim

# Dependencies
python3 -m pip install black pynvim

# Install all the plugins
nvim --cmd ":source $path_to_vim/init.vim" \
	-c ":PlugInstall" \
	-c ":qa!" 2>/dev/null

# vim-jsbeautify
cp ./.editorconfig $path_to_vim/

# sym-link vim to nvim
ln -sf $HOME/.config/nvim/init.vim $HOME/.vimrc
ln -sf $HOME/.config/nvim/ $HOME/.vim
ln -sf /usr/bin/nvim ~/.local/bin/vim

echo -e "[DONE] Installing and setting up stuff for Vim\n"
