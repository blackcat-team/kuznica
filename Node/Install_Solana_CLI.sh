#!/bin/bash
sh -c "$(curl -sSfL https://release.solana.com/v1.18.2/install)"
sleep 2
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
sleep 2
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
sleep 2
