#/bin/bash

set -e
source ../../var.sh

sudo gpasswd -a $USER docker
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
