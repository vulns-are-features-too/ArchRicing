#!/usr/bin/bash

r2pm init
r2pm -i $(cat ./plugins | tr '\n' ' ') || echo "Failed to install plugins"
