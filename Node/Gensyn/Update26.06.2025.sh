#!/bin/bash

echo "*******************************************************"
curl -sSL https://raw.githubusercontent.com/blackcat-team/kuznica/main/kuznica_logo.sh | bash
echo "*******************************************************"

npm install -g yarn --force
yarn install
sudo npm install encoding pino-pretty

rm -rf rl-swarm
git clone https://github.com/gensyn-ai/rl-swarm
cd rl-swarm

python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh
