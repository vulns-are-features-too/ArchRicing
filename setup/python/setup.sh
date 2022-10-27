#!/bin/bash

set -e

# debugging
cd ~
[ -d .virtualenvs ] || mkdir .virtualenvs
cd .virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
