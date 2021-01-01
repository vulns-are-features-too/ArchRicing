#!/bin/bash

# Add apparmor to kernel
cp grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# aa-notify
sudo groupadd -r audit
sudo gpasswd -a $USER audit
echo 'log_group = audit' | sudo tee -a /etc/audit/auditd.conf

sudo systemctl enable apparmor.service
