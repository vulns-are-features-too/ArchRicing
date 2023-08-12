#!/bin/bash

set -e
source ../../var.sh

echo -e "[START] Setting up LSP stuff" | tee -a "$log_file"

bash ./python.sh

echo -e "[DONE] Setting up LSP stuff" | tee -a "$log_file"
