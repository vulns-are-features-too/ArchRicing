#!/bin/bash
# This assumes TPM 2

systemd-detect-virt -q && exit
sudo pacman -S tpm2-abrmd tpm2-tools
sudo systemctl enable tpm2-abrmd
