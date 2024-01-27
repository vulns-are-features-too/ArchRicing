#!/bin/bash
set -e

jq -r 'to_entries[] | select(.value.src == "pacman") | select(.value.is_min_required == true) | .key' < pkgs.json > pacman-min
jq -r 'to_entries[] | select(.value.src == "pacman") | select(.value.is_host_only == true) | .key' < pkgs.json > pacman-host
jq -r 'to_entries[] | select(.value.src == "pacman") | select(.value.is_guest_only == true) | .key' < pkgs.json > pacman-guest
jq -r 'to_entries[] | select(.value.src == "pacman") | select(.value.is_min_required != true and .value.is_host_only != true and .value.is_guest_only != true) | .key' < pkgs.json > pacman

jq -r 'to_entries[] | select(.value.src == "aur") | select(.value.is_host_only == true) | .key' < pkgs.json > aur-host
jq -r 'to_entries[] | select(.value.src == "aur") | select(.value.is_guest_only == true) | .key' < pkgs.json > aur-guest
jq -r 'to_entries[] | select(.value.src == "aur") | select(.value.is_min_required != true and .value.is_host_only != true and .value.is_guest_only != true) | .key' < pkgs.json > aur

jq -r 'to_entries[] | select(.value.src == "pipx") | .key' < pkgs.json > pipx
jq -r 'to_entries[] | select(.value.src == "npm") | .key' < pkgs.json > npm
jq -r 'to_entries[] | select(.value.src == "rust") | .key' < pkgs.json > rust
jq -r 'to_entries[] | select(.value.src == "go") | .key' < pkgs.json > go
