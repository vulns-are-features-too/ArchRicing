#!/bin/sh

# exist if not host
systemd-detect-virt && exit

# libvirtd
sudo groupadd libvirtd
sudo usermod -aG libvirtd "$USER"
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

sudo modprobe vboxdrv

#sudo cp modprobe.conf /etc/modprobe.d/
