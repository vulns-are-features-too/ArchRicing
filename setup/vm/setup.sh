#!/bin/sh

set -e
source ../../var.sh

echo "[START] Setting up VMs" | tee -a "$log_file"
# exist if not host
systemd-detect-virt -q && exit
sudo modprobe vboxdrv

#sudo cp modprobe.conf /etc/modprobe.d/
echo "[DONE] Setting up VMs" | tee -a "$log_file"
