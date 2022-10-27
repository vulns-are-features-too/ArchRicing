#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up tridactyl" | tee -a "$log_file"
curl -fsSl https://raw.githubusercontent.com/tridactyl/tridactyl/master/native/install.sh -o /tmp/trinativeinstall.sh && bash /tmp/trinativeinstall.sh master
echo "[DONE] Setting up tridactyl" | tee -a "$log_file"
