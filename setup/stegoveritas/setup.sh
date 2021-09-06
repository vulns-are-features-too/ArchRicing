#!/usr/bin/sh

echo "[START] Setting up stegoveritas" | tee -a "$log_file"
stegoveritas_install_deps
echo "[DONE] Setting up stegoveritas" | tee -a "$log_file"
