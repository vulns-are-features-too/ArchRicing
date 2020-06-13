#!/usr/bin/bash

set -e


##############################
# Options and Variables
##############################

source ./var.sh

##############################
# Declare functions
##############################

echo -e "Setting up functions\n"

pre_install(){
	echo -e "[START] Preprocessing\n"

	mkdir -p $path_to_tools $HOME/.config

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

	echo -e "Installing main tools\n"
	sudo pacman -Syu --noconfirm --needed $(cat $path_to_pkgs/main.txt | tr '\n' ' ')

	echo -e "[DONE] Installing with standard package manager\n"
}

install_aur(){
	echo -e "[START] Installing stuff from the AUR\n"

	yay -S $(cat $path_to_pkgs/aur.txt | tr '\n' ' ')

	echo -e "[DONE] Installing stuff from the AUR\n"
}

install_python(){
	echo -e "[START] Installing python modules\n"

	pip3 install -r $path_to_pkgs/python.txt

	echo -e "[DONE] Installing python modules\n"
}

install_gitmake(){
	echo -e "[START] Installing stuff from github with make\n"

	while IFS= read -r line; do
		tmp=$(cat $line | rev | cut -d "/" -f 1 | rev)
		git clone $line $path_to_tools/$tmp
		cd $path_to_tools/$tmp
		make
		sudo make install
	done < $path_to_pkgs/gitmake.txt
	cd $path_current

	echo -e "[DONE] Installing stuff from github with make\n"
}

install_manual(){
	echo -e "[START] Installing some tools semi-manually\n"

	# Loop through /manual_install and run every script
	for dir in ./manual_install/*; do
		bash $dir/install.sh
	done

	echo -e "[START] Installing some tools semi-manually\n"
}

dotfiles(){
	echo -e "[START] Installing dot files\n"

	git clone $url_to_dotfiles $path_to_dotfiles

	for line in $path_to_dotfiles/home/.*; do
		target=$(echo $line | cut -d \/ -f 7)
		[ $target != "." ] && [ $target != ".." ] && ln -sf $line $HOME/$target
	done

	for line in $path_to_dotfiles/config/*; do
		target=$(echo $line | cut -d \/ -f 7)
		ln -sf $line $HOME/.config/$target
	done

	echo -e "[DONE] Installing dot files\n"
}

cron(){
	echo -e "[START] Copying cron jobs\n"

#	cp ./cron/user/* $path_to_cron_user
#	cp ./cron/root/* $path_to_cron_root

	echo -e "[DONE] Copying cron jobs\n"
}

setup(){
	echo -e "[START] Setting up tools\n"

	# Loop through /setup and run every script
	for dir in ./setup/*; do
		bash $dir/setup.sh
	done

	echo -e "[DONE] Setting up tools\n"
}

misc(){
	# touchpad stuff
	sudo cp ./misc/30-touchpad.conf /etc/X11/xorg.conf.d/

	# allow acpilight's xbacklight to control brightness without sudo
	sudo cp ./90-backlight.rules /etc/udev/rules.d/
}

post_install(){
	echo -e "[START] Post-installtion\n"

	cp ./.custom $HOME
	chmod +x $HOME/.custom/scripts/*

	echo "updatedb"
	sudo updatedb

	chmod +x $HOME/.config/bspwm/bspwmrc

	echo -e "Pulling docker images\n"
	while read -r $img; do
		echo -e "docker pull $img\n"
		docker pull $img
	done < ./pkglist/docker_images.txt

	sudo systemctl enable cronie

	echo -e "[DONE] Post-installtion\n"
}



##############################
# main() - Run all the stuff
##############################

echo -e "Running install and setup\n"

pre_install
add_repos
install_pkg
install_aur
install_python
install_gitmake
install_manual
dotfiles
cron
setup
misc
post_install

echo -e "Done with everything!\n"
