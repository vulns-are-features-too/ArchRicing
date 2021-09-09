#!/bin/sh

set -e
source ../../var.sh

echo "[START] Setting up VMs" | tee -a "$log_file"
if [ systemd-detect-virt ]; then
  sudo modprobe vboxdrv
else
  sudo usermod -aG vboxsf $USER
fi

#sudo cp modprobe.conf /etc/modprobe.d/
echo "[DONE] Setting up VMs" | tee -a "$log_file"
