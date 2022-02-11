#/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up docker" | tee -a "$log_file"
sudo gpasswd -a $USER docker
sudo groupadd docker || echo "Group 'docke already exists'"
sudo usermod -aG docker $USER
newgrp docker
echo "[DONE] Setting up docker" | tee -a "$log_file"
