#!/usr/bin/bash

# Downloads miscellaneous tools & wordlists
set -e
source ../../var.sh

echo "[START] Setting up misc" | tee -a "$log_file"
mkdir -p "$HOME/tools/payloads" || true
curr=$(pwd)

cd ~/tools
while read -r line; do
	git clone $line --depth 1
done < "$curr/tools"

cd payloads
while read -r line; do
	git clone $line
done < "$curr/payloads.txt"

# OneRuleToRuleThemAll
mkdir $HOME/tools/password_cracking_rules
wget https://raw.githubusercontent.com/NotSoSecure/password_cracking_rules/master/OneRuleToRuleThemAll.rule -o ~/tools/password_cracking_rules/OneRuleToRuleThemAll.rule
ln -sf /usr/share/john/rules/ $HOME/tools/password_cracking_rules/hashcat_rules
ln -sf /usr/share/john/rules/ $HOME/tools/password_cracking_rules/john_rules

cd $path_current
echo "[DONE] Setting up misc" | tee -a "$log_file"
