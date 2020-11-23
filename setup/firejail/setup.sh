#!/bin/sh

echo -e "[START] Setting up firejail\n"

set -e
source ../../var.sh

sudo aa-enforce firejail-default

echo "Copying firejail profiles"
sudo cp ./profiles/* /etc/firejail/

echo -e "[START] Setting up firejail\n"
