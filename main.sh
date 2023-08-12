#!/bin/bash

set -e

##############################
# Options and Variables
##############################

source var.sh

##############################
# Declare functions
##############################

pre_install() {
  echo -e "[START] Preprocessing\n" | tee -a "$log_file"

  mkdir -p "$path_to_tools" "$HOME/.config"

  echo -e "[DONE] Preprocessing\n" | tee -a "$log_file"
}

add_repos() {
  echo -e "[START] Installing repositories\n" | tee -a "$log_file"

  # Blackarch
  echo -e "Adding Blackarch repository\n" | tee -a "$log_file"
  curl -O https://blackarch.org/strap.sh
  sudo chmod +x strap.sh
  sudo ./strap.sh
  rm strap.sh
  sudo pacman -Syyu
  sudo pacman -S --noconfirm blackman
  echo -e "Finished adding Blacharch repository\n" | tee -a "$log_file"

  # Archstrike
  echo -e "Adding Archstrike repository\n" | tee -a "$log_file"
  echo -e "\n[archstrike]\nServer = https://mirror.archstrike.org/\$arch/\$repo\n" | sudo tee -a /etc/pacman.conf
  signature="9D5F1C051D146843CDA4858BDE64825E7CBC0D51"
  #signature=$(curl -s 'https://archstrike.org/wiki/setup' | grep -oP 'pacman-key --lsign-key [A-Z0-9]+' | cut -d' ' -f3 | head -1)
  sudo pacman-key --init
  sudo dirmngr < /dev/null
  wget https://archstrike.org/keyfile.asc
  sudo pacman-key --add keyfile.asc
  rm keyfile.asc
  sudo pacman -Sy
  sudo pacman-key --lsign-key "$signature"
  sudo pacman -S archstrike-keyring archstrike-mirrorlist
  sudo sed -i 's|Server = https://mirror.archstrike.org/$arch/$repo|Include = /etc/pacman.d/archstrike-mirrorlist|' /etc/pacman.conf
  sudo pacman -Syy --noconfirm
  echo -e "Finished adding Archstrike repository\n" | tee -a "$log_file"

  echo -e "[DONE] Installing repositories\n" | tee -a "$log_file"
}

install_pkg_min() {
  echo -e "[START] Installing minimal packages\n" | tee -a "$log_file"

  sudo pacman -S --needed - < "$path_to_pkgs/pacman-min" || exit 1

  echo -e "[DONE] Installing minimal packages \n" | tee -a "$log_file"
}

dotfiles() {
  echo -e "[START] Installing dot files\n" | tee -a "$log_file"

  [ -d "$path_to_dotfiles" ] || git clone --depth 1 --recurse-submodules "$url_to_dotfiles" "$path_to_dotfiles"
  [ -d "$path_to_scripts" ] || git clone --depth 1 "$url_to_scripts" "$path_to_scripts"

  for line in "$path_to_dotfiles"/home/.*; do
    target="$(echo "$line" | cut -d/ -f 7)"
    [ "$target" != "." ] && [ "$target" != ".." ] && ln -sf "$line" "$HOME/$target"
  done || exit 1

  for line in "$path_to_dotfiles"/config/*; do
    target="$(echo "$line" | cut -d/ -f 7)"
    ln -sf "$line" "$HOME/.config/$target"
  done || exit 1

  echo -e "[DONE] Installing dot files\n" | tee -a "$log_file"
}

install_pkg() {
  echo -e "[START] Installing with standard package manager\n" | tee -a "$log_file"

  files=("$path_to_pkgs/pacman")
  systemd-detect-virt -q && files+=("$path_to_pkgs/pacman-guest") || files+=("$path_to_pkgs/pacman-guest")
  cat "${files[@]}" | sudo pacman -S --needed --disable-download-timeout - || exit 1

  echo -e "[DONE] Installing with standard package manager\n" | tee -a "$log_file"
}

install_aur() {
  echo -e "[START] Installing stuff from the AUR\n" | tee -a "$log_file"

  files=("$path_to_pkgs/aur")
  systemd-detect-virt -q || files+=("$path_to_pkgs/aur")
  readarray -t pkgs <<< "$(cat "${files[@]}")"
  yay -Sa --needed "${pkgs[@]}" || exit 1

  echo -e "[DONE] Installing stuff from the AUR\n" | tee -a "$log_file"
}

install_pip() {
  echo -e "[START] Installing python modules\n" | tee -a "$log_file"

  pip3 install --user -r "$path_to_pkgs/pip" || exit 1
  while read -r line; do
    python3 -m pipx install "$line"
  done < "$path_to_pkgs/pipx"

  echo -e "[DONE] Installing python modules\n" | tee -a "$log_file"
}

install_npm() {
  echo -e "[START] Installing npm tools\n" | tee -a "$log_file"

  # Setup npm to be used without sudo
  npm config set prefix ~/.npm
  export PATH="$PATH:$HOME/.npm/bin"
  xargs npm install -g < "$path_to_pkgs/npm" || exit 1

  echo -e "[DONE] Installing npm tools\n" | tee -a "$log_file"
}

install_rust() {
  echo -e "[START] Installing rust tools\n" | tee -a "$log_file"

  rustup default stable

  # Rust Language Server
  rustup component add clippy rust-analysis rust-analyzer rust-docs rust-src rustfmt

  cargo install cargo-audit --features=fix
  cargo install cargo-update

  xargs cargo install < "$path_to_pkgs/rust"

  echo -e "[DONE] Installing rust tools\n" | tee -a "$log_file"
}

install_go() {
  echo -e "[START] Installing go tools\n" | tee -a "$log_file"

  go env -w GO111MODULE=on
  xargs -I pkg go install "pkg" < "$path_to_pkgs/go"

  echo -e "[DONE] Installing go tools\n" | tee -a "$log_file"
}

install_ruby() {
  echo -e "[START] Installing ruby tools\n" | tee -a "$log_file"

  readarray -t pkgs < "$path_to_pkgs/ruby"
  gem install "${pkgs[@]}"

  echo -e "[DONE] Installing ruby tools\n" | tee -a "$log_file"
}

setup() {
  echo -e "[START] Setting up tools\n" | tee -a "$log_file"

  # Loop through /setup and run every script
  for dir in ./setup/*; do
    cd "$dir"
    bash setup.sh
    cd "$path_current"
  done || exit 1

  echo -e "[DONE] Setting up tools\n" | tee -a "$log_file"
}

misc() {
  if [ "$(systemd-detect-virt -q)" ]; then
    sudo cp ./misc/powertop.service /etc/systemd/system/
    sudo cp ./misc/audio_powersave.conf /etc/modprobe.d/
    sudo cp ./misc/logind.conf /etc/systemd/

    # touchpad stuff
    sudo cp ./misc/30-touchpad.conf /etc/X11/xorg.conf.d/

    # allow acpilight's xbacklight to control brightness without sudo
    sudo cp ./misc/backlight.rules /etc/udev/rules.d/
    sudo cp /usr/share/ddcutil/data/90-nvidia-i2c.conf /etc/X11/xorg.conf.d/
    sudo cp /usr/share/ddcutil/data/45-ddcutil-i2c.rules /usr/share/ddcutil/data/45-ddcutil-usb.rules
    sudo usermod -aG i2c video "$USER"
  fi
}

post_install() {
  echo -e "[START] Post-installtion\n" | tee -a "$log_file"

  # create some directories
  mkdir -p \
    ~/{Desktop,Downloads,Videos} \
    ~/torrents/{downloads,incomplete,seeds,torrents} \
    ~/Pictures/screenshots

  echo "updatedb"
  sudo updatedb

  sudo systemctl enable apparmor
  sudo systemctl enable archlinux-keyring-wkd-sync.timer
  sudo systemctl enable bluetooth
  sudo systemctl enable cronie
  sudo systemctl enable NetworkManager
  sudo systemctl disable NetworkManager-wait-online.service
  systemctl --user enable pueued.service
  #sudo systemctl enable powertop.service

  if [ "$(systemd-detect-virt -q)" ]; then
    sudo systemctl enable auto-cpufreq
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
