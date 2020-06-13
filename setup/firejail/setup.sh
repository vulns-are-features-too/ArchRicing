#!/usr/bin/sh

echo -e "[START] Setting up firejail\n"

set -e
source var.sh

echo "firecfg"
sudo firecfg

echo "Copying firejail profiles"
sudo cp ./profiles/* /etc/firejail/

# Remove some unwanted symlinks
sudo rm /usr/local/bin/hashcat
sudo rm /usr/local/bin/pandoc
sudo rm /usr/local/bin/redshift

echo -e "[START] Setting up firejail\n"
