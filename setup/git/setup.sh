#!/bin/bash

set -e
source ../../var.sh

echo "[START] Setting up git" | tee -a "$log_file"

cp ./.gitconfig ~/

# gh
gh config set git_protocol ssh
gh config set editor "$EDITOR"
gh config set pager bat
gh config set browser "$BROWSER"

echo "[DONE] Setting up git" | tee -a "$log_file"
