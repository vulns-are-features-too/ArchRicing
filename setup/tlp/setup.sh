#!/bin/bash

systemd-detect-virt -q && exit
sudo cp tlp.conf /etc/
sudo systemctl enable tlp
