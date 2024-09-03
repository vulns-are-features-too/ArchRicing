#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up apparmor" | tee -a "$log_file"

# aa-notify
sudo groupadd -r audit
sudo gpasswd -a "$USER" audit
echo 'log_group = audit' | sudo tee -a /etc/audit/auditd.conf

sudo systemctl enable apparmor.service
echo "[DONE] Setting up apparmor" | tee -a "$log_file"
