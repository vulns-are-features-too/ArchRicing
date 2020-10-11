#!/usr/bin/bash

# Downloads miscellaneous tools & wordlists
set -e
source ../../var.sh

mkdir -p $HOME/tools/payloads || continue

cd ~/tools

# SecList
git clone https://github.com/danielmiessler/SecLists

# knock.py
git clone https://github.com/grongor/knock

cd payloads

# PayloadAllTheThings
git clone https://github.com/swisskyrepo/PayloadsAllTheThings

# linpeas/winpeas
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite

# OneRuleToRuleThemAll
wget https://raw.githubusercontent.com/NotSoSecure/password_cracking_rules/master/OneRuleToRuleThemAll.rule -o ~/tools/password_cracking_rules/OneRuleToRuleThemAll.rule

cd $path_current
