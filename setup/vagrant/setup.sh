#!/usr/bin/sh

set -e
source ../../var.sh

systemd-detect-virt -q && exit
echo "[START] Setting up vagrant" | tee -a "$log_file"
vagrant plugin install vagrant-reload
echo "[DONE] Setting up vagrant" | tee -a "$log_file"
