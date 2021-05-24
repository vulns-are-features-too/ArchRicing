#!/bin/bash

set -e
source ../../var.sh

arduino-cli core install arduino:avr arduino:megaavr
sudo usermod -aG uucp "$USER"
