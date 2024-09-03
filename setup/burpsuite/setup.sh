#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up burpsuite" | tee -a "$log_file"
burp_tools="$path_to_tools/burpsuite"
mkdir -p "$burp_tools"
cd "$burp_tools"

echo "Setting up Jython"
wget 'https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.3/jython-standalone-2.7.3.jar'

echo "Installing bugcrowd's HUNT"
wget https://raw.githubusercontent.com/bugcrowd/HUNT/master/Burp/hunt_scanner.py
wget https://raw.githubusercontent.com/bugcrowd/HUNT/master/Burp/hunt_methodology.py
echo "Install HUNT: https://github.com/bugcrowd/HUNT"
echo "[DONE] Setting up burpsuite" | tee -a "$log_file"
