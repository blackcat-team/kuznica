#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential curl wget git unzip zip software-properties-common ca-certificates gnupg lsb-release htop net-tools neofetch tmux vim -y
sudo apt update && sudo apt install -y pkg-config libssl-dev
sudo apt-get update -qq && sudo apt-get install -y -q clang
git clone https://github.com/boundless-xyz/boundless
cd boundless
bash -x ./scripts/setup.sh
