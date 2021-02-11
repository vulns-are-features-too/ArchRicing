#!/bin/bash

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Rust Language Server
rustup component add rls rust-analysis rust-src
