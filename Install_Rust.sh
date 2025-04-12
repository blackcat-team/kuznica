#!/bin/bash
set -e
rustup install 1.80.0
source "$HOME/.cargo/env"
rustup update
sleep 2
