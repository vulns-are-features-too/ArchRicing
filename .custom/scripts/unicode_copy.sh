#!/usr/bin/sh

grep -v '#' ~/.custom/scripts/unicode | dmenu -i -l 10 | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard
