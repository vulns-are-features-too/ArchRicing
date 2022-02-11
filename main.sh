#!/usr/bin/bash

set -e

##############################
# Options and Variables
##############################

source var.sh

##############################
# Declare functions
##############################

pre_install(){
	echo -e "[START] Preprocessing\n" | tee -a "$log_file"

	mkdir -p "$path_to_tools" "$HOME/.config"

	echo -e "[DONE] Preprocessing\n" | tee -a "$log_file"
}

add_repos(){
	echo -e "[START] Installing repositories\n" | tee -a "$log_file"

	# Blackarch
	echo -e "Adding Blackarch repository\n" | tee -a "$log_file"
	curl -O https://blackarch.org/strap.sh
	sudo chmod +x strap.sh
	sudo ./strap.sh
	rm strap.sh
	sudo pacman -S --noconfirm blackman
	echo -e "Finished adding Blacharch repository\n" | tee -a "$log_file"

	# Archstrike
	echo -e "Adding Archstrike repository\n" | tee -a "$log_file"
	echo -e "\n[archstrike]\nServer = https://mirror.archstrike.org/\$arch/\$repo\n" | sudo tee -a /etc/pacman.conf
	# 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
	signature=$(curl -s 'https://archstrike.org/wiki/setup' | grep -oP 'pacman-key --lsign-key [A-Z0-9]+' | cut -d' ' -f3 | head -1)
	sudo pacman-key --init
	sudo dirmngr < /dev/null
	wget https://archstrike.org/keyfile.asc
	sudo pacman-key --add keyfile.asc
	rm keyfile.asc*
	sudo pacman-key --lsign-key "$signature"
	sudo pacman -Syy --noconfirm
	echo -e "Finished adding Archstrike repository\n" | tee -a "$log_file"

	echo -e "[DONE] Installing repositories\n" | tee -a "$log_file"
}

install_pkg_min(){
	echo -e "[START] Installing minimal packages\n" | tee -a "$log_file"

	pkg="$(tr '\n' ' ' < "$path_to_pkgs"/pacman-min)"
	sudo pacman -S --needed $pkg || exit 1

	echo -e "[DONE] Installing minimal packages \n" | tee -a "$log_file"
}

dotfiles(){
	echo -e "[START] Installing dot files\n" | tee -a "$log_file"

	[ -d "$HOME/git/dotfiles" ] || git clone "$url_to_dotfiles" "$path_to_dotfiles"

	for line in "$path_to_dotfiles"/home/.*; do
		target="$(echo "$line" | cut -d \/ -f 7)"
		[ "$target" != "." ] && [ "$target" != ".." ] && ln -sf $line "$HOME/$target"
	done || exit 1

	for line in "$path_to_dotfiles"/config/*; do
		target="$(echo $line | cut -d \/ -f 7)"
		ln -sf "$line" "$HOME/.config/$target"
	done || exit 1

	echo -e "[DONE] Installing dot files\n" | tee -a "$log_file"
}

install_pkg(){
	echo -e "[START] Installing with standard package manager\n" | tee -a "$log_file"

	pkg="$(tr '\n' ' ' < "$path_to_pkgs"/pacman)"
	 systemd-detect-virt -q && pkg="$pkg $(tr '\n' ' ' < "$path_to_pkgs"/pacman-guest)" || pkg="$pkg $(tr '\n' ' ' < "$path_to_pkgs"/pacman-host)"
	sudo pacman -S --needed --disable-download-timeout $pkg || exit 1

	echo -e "[DONE] Installing with standard package manager\n" | tee -a "$log_file"
}

install_aur(){
	echo -e "[START] Installing stuff from the AUR\n" | tee -a "$log_file"

	pkg="$(tr '\n' ' ' < "$path_to_pkgs"/aur)"
	systemd-detect-virt -q || pkg="$pkg $(tr '\n' ' ' < "$path_to_pkgs"/aur-host)"
	yay -S $pkg || exit 1

	echo -e "[DONE] Installing stuff from the AUR\n" | tee -a "$log_file"
}

install_pip(){
	echo -e "[START] Installing python modules\n" | tee -a "$log_file"

	pip3 install --user -r "$path_to_pkgs/pip" || exit 1
	while read -r line; do
		python3 -m pipx install "$line"
	done < $path_to_pkgs/pipx

	echo -e "[DONE] Installing python modules\n" | tee -a "$log_file"
}

install_npm(){
	echo -e "[START] Installing npm tools\n" | tee -a "$log_file"

	# Setup npm to be used without sudo
	npm config set prefix ~/.npm
	export PATH="$PATH:$HOME/.npm/bin"
	xargs npm install -g < "$path_to_pkgs/npm" || exit 1

	echo -e "[DONE] Installing npm tools\n" | tee -a "$log_file"
}

install_rust(){
	echo -e "[START] Installing rust tools\n" | tee -a "$log_file"

	# Install rustup
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env

	# Rust Language Server
	rustup component add rls rust-analysis rust-src

	cargo install cargo-audit --features=fix

	xargs cargo install < "$path_to_pkgs/rust"

	echo -e "[DONE] Installing rust tools\n" | tee -a "$log_file"
}

install_go(){
	echo -e "[START] Installing go tools\n" | tee -a "$log_file"

	go env -w GO111MODULE=on
	xargs -I pkg go get -u "pkg" < "$path_to_pkgs/go"

	echo -e "[DONE] Installing go tools\n" | tee -a "$log_file"
}

install_ruby(){
	echo -e "[START] Installing ruby tools\n" | tee -a "$log_file"

	gem install $(tr '\n' ' ' < $path_to_pkgs/ruby)

	echo -e "[DONE] Installing ruby tools\n" | tee -a "$log_file"
}

setup(){
	echo -e "[START] Setting up tools\n" | tee -a "$log_file"

	# Loop through /setup and run every script
	for dir in ./setup/*; do
		cd "$dir"
		bash setup.sh
		cd "$path_current"
	done || exit 1

	echo -e "[DONE] Setting up tools\n" | tee -a "$log_file"
}

misc(){
	# touchpad stuff
	sudo cp ./misc/30-touchpad.conf /etc/X11/xorg.conf.d/

	# allow acpilight's xbacklight to control brightness without sudo
	sudo cp ./misc/backlight.rules /etc/udev/rules.d/
	sudo usermod -aG video "$USER"

  sudo cp ./misc/powertop.service /etc/systemd/system/
  sudo cp ./misc/audio_powersave.conf /etc/modprobe.d/
}

post_install(){
	echo -e "[START] Post-installtion\n" | tee -a "$log_file"

	echo "updatedb"
	sudo updatedb

	sudo systemctl enable NetworkManager
	sudo systemctl enable apparmor
	sudo systemctl enable bluetooth
	sudo systemctl enable cronie
  sudo systemctl disable NetworkManager-wait-online.service
  sudo systemctl enable powertop.service

	if [ "$(systemd-detect-virt -q)" ]; then
		sudo systemctl enable syslog-ng@default
		systemctl enable --user mpd
	fi

	sudo usermod -aG audit,mount,network,video "$USER"

	[ "$SHELL" = "/usr/bin/zsh" ] || chsh -s "$(which zsh)"

	echo -e "[DONE] Post-installtion\n" | tee -a "$log_file"
}



##############################
# main() - Run all the stuff
##############################

echo -e "Running install and setup\n"

#pre_install
#add_repos
#install_pkg_min
#dotfiles
#install_pkg
#install_aur
#install_pip
#install_npm
#install_rust
#install_go
#setup
#misc
#post_install

echo -e "Done with everything!\n"
