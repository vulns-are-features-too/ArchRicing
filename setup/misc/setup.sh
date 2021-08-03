#!/usr/bin/bash

# Downloads miscellaneous tools & wordlists
systemd-detect-virt -q && exit
set -e
source ../../var.sh

mkdir -p $HOME/tools/payloads || continue

cd ~/tools
while read -r line; do
	git clone $line --depth 1
done < tools

cd payloads
while read -r line; do
	git clone $line
done < payloads.txt

# OneRuleToRuleThemAll
mkdir $HOME/tools/password_cracking_rules
wget https://raw.githubusercontent.com/NotSoSecure/password_cracking_rules/master/OneRuleToRuleThemAll.rule -o ~/tools/password_cracking_rules/OneRuleToRuleThemAll.rule
ln -sf /usr/share/john/rules/ $HOME/tools/password_cracking_rules/hashcat_rules
ln -sf /usr/share/john/rules/ $HOME/tools/password_cracking_rules/john_rules

cd $path_current
