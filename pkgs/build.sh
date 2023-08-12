#!/bin/bash
set -e
jq -r -f filter.jq pkgs.json
