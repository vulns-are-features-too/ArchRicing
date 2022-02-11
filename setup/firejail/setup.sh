#!/bin/sh

set -e
source ../../var.sh

echo -e "[START] Setting up firejail" | tee -a "$log_file"
sudo systemctl enable --now apparmor
sudo aa-enforce firejail-default
echo "Copying firejail profiles"
sudo cp ./profiles/* /etc/firejail/
echo -e "[DONE] Setting up firejail" | tee -a "$log_file"
