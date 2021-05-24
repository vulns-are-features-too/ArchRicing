#!/usr/bin/bash

set -e

##############################
# Options and Variables
##############################

source var.sh

##############################
# Declare functions
##############################

echo -e "Setting up functions\n"

pre_install(){
	echo -e "[START] Preprocessing\n"

	mkdir -p "$path_to_tools" "$HOME/.config"

	echo -e "[DONE] Preprocessing\n"
}

add_repos(){
	echo -e "[START] Installing repositories\n"

	# Blackarch
	echo -e "Adding Blackarch repository\n"
	curl -O https://blackarch.org/strap.sh
	sudo chmod +x strap.sh
	sudo ./strap.sh
	rm strap.sh
	sudo pacman -S --noconfirm blackman
	echo -e "Finished adding Blacharch repository\n"

	# Archstrike
	echo -e "Adding Archstrike repository\n"
	echo -e "\n[archstrike]\nServer = https://mirror.archstrike.org/\$arch/\$repo\n" | sudo tee -a /etc/pacman.conf
	sudo pacman-key --init
	sudo dirmngr < /dev/null
	wget https://archstrike.org/keyfile.asc
	sudo pacman-key --add keyfile.asc
	rm keyfile.asc*
	sudo pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
	sudo pacman -Syy --noconfirm
	echo -e "Finished adding Archstrike repository\n"

	echo -e "[DONE] Installing repositories\n"
}

install_pkg(){
	echo -e "[START] Installing with standard package manager\n"

	pkg="$(tr '\n' ' ' < "$path_to_pkgs"/pacman)"
	[ "$(systemd-detect-virt)" == "none" ] && pkg="$pkg $(tr '\n' ' ' < "$path_to_pkgs"/pacman)"
	sudo pacman -S --needed $pkg || exit 1

	echo -e "[DONE] Installing with standard package manager\n"
}

install_aur(){
	echo -e "[START] Installing stuff from the AUR\n"

	pkg="$(tr '\n' ' ' < "$path_to_pkgs"/aur)"
	[ "$(systemd-detect-virt)" == "none" ] && pkg="$pkg $(tr '\n' ' ' < "$path_to_pkgs"/aur-host)"
	yay -S $pkg || exit 1

	echo -e "[DONE] Installing stuff from the AUR\n"
}

install_pip(){
	echo -e "[START] Installing python modules\n"

	pip3 install -r "$path_to_pkgs/pip" || exit 1
	while read -r line; do
		python3 -m pipx install "$line"
	done < $path_to_pkgs/pipx

	echo -e "[DONE] Installing python modules\n"
}

install_npm(){
	echo -e "[START] Installing some tools semi-manually\n"

	# Setup npm to be used without sudo
	npm config set prefix ~/.npm
	export PATH="$PATH:$HOME/.npm/bin"
	xargs npm install -g < "$path_to_pkgs/npm" || exit 1

	echo -e "[DONE] Installing some tools semi-manually\n"
}

download_tools(){

	[ "$(systemd-detect-virt)" == "none" ] || exit

	echo -e "[START] Downloading tools\n"

	echo "Cloning to $path_to_tools"
	cd "$path_to_tools"
	while IFS= read -r line; do
		git clone "$line"
	done < "$path_to_pkgs/gitclone"

	cd "$path_current"

	echo -e "[DONE] Downloading tools\n"
}

dotfiles(){
	echo -e "[START] Installing dot files\n"

	[ -d "$HOME/git/dotfiles" ] || git clone "$url_to_dotfiles" "$path_to_dotfiles"

	for line in "$path_to_dotfiles"/home/.*; do
		target="$(echo "$line" | cut -d \/ -f 7)"
		[ "$target" != "." ] && [ "$target" != ".." ] && ln -sf $line "$HOME/$target"
	done || exit 1

	for line in "$path_to_dotfiles"/config/*; do
		target="$(echo $line | cut -d \/ -f 7)"
		ln -sf "$line" "$HOME/.config/$target"
	done || exit 1

	echo -e "[DONE] Installing dot files\n"
}

setup(){
	echo -e "[START] Setting up tools\n"

	# Loop through /setup and run every script
	for dir in ./setup/*; do
		cd "$dir"
		bash setup.sh
		cd "$path_current"
	done || exit 1

	echo -e "[DONE] Setting up tools\n"
}

misc(){
	# touchpad stuff
	sudo cp ./misc/30-touchpad.conf /etc/X11/xorg.conf.d/

	# allow acpilight's xbacklight to control brightness without sudo
	sudo cp ./misc/90-backlight.rules /etc/udev/rules.d/
}

post_install(){
	echo -e "[START] Post-installtion\n"

	echo "updatedb"
	sudo updatedb

	sudo systemctl enable NetworkManager
	sudo systemctl enable bluetooth
	sudo systemctl enable apparmor
	sudo systemctl enable cronie
	sudo systemctl enable openntpd
	systemctl enable --user mpd

  chsh -s "$(which zsh)"

	echo -e "[DONE] Post-installtion\n"
}



##############################
# main() - Run all the stuff
##############################

echo -e "Running install and setup\n"

#pre_install
#add_repos
#install_pkg
#install_aur
#install_pip
#install_npm
#download_tools
#dotfiles
#setup
#misc
#post_install

echo -e "Done with everything!\n"
