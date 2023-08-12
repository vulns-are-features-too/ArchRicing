#!/bin/bash

set -e

pipx install python-lsp-server
pipx inject python-lsp-server pylsp-mypy
pipx inject python-lsp-server pylsp-rope
pipx inject python-lsp-server python-lsp-black
pipx inject python-lsp-server python-lsp-ruff
