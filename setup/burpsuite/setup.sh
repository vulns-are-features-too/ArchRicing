#!/bin/bash
set -e
source ../../var.sh

mkdir $path_to_tools/burpsuite
cd $path_to_tools/burpsuite

echo "Setting up Jython"
wget $(curl -s https://www.jython.org/download.html | grep "jython-standalone-.*\.jar" | cut -d'"' -f2)
sudo mv jython-standalone* /usr/share/burpsuite/

echo "Installing bugcrowd's HUNT"
wget https://raw.githubusercontent.com/bugcrowd/HUNT/master/Burp/hunt_scanner.py
wget https://raw.githubusercontent.com/bugcrowd/HUNT/master/Burp/hunt_methodology.py
echo "Install HUNT: https://github.com/bugcrowd/HUNT"
