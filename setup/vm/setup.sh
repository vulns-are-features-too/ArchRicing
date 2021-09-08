#!/bin/sh

set -e
source ../../var.sh

systemd-detect-virt -q && exit
echo "[START] Setting up VMs" | tee -a "$log_file"
sudo modprobe vboxdrv

#sudo cp modprobe.conf /etc/modprobe.d/
echo "[DONE] Setting up VMs" | tee -a "$log_file"
