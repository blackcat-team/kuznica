#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
pkill -f "SCREEN.*gensyn"

screen -S gensyn

npm install -g yarn --force
yarn install

rm -rf rl-swarm
git clone https://github.com/gensyn-ai/rl-swarm

cd rl-swarm
python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh
