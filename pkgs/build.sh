#!/bin/bash
set -e

filter() {
  # Usage: filter src [outfile] [additional_filter]
  src="$1"
  if [ $# -eq 1 ]; then
    file="$1"
  else
    file="$2"
  fi
  if [ $# -eq 3 ]; then
    filter=" and select($3)"
  fi
  jq -r "to_entries[] | select(.value.src == \"$src\" $filter) | .key" < pkgs.json > "$file"
}

filter pacman pacman-min ".value.is_min_required == true"
filter pacman pacman-host ".value.is_host_only == true"
filter pacman pacman-guest ".value.is_guest_only == true"
filter pacman pacman ".value.is_min_required != true and .value.is_host_only != true and .value.is_guest_only != true"

filter aur aur-host ".value.is_host_only == true"
filter aur aur-guest ".value.is_guest_only == true"
filter aur aur ".value.is_min_required != true and .value.is_host_only != true and .value.is_guest_only != true"

filter pipx
filter npm
filter rust
filter go
