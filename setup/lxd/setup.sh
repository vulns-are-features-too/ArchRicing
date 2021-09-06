#!/bin/bash

set -e
source ../../var.sh

sudo usermod -aG lxd $USER
