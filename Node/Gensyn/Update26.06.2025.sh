#!/bin/bash

echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/main/kuznica_logo.sh | bash
echo "*******************************************************"

# Убить старую screen-сессию, если есть
screen -S gensyn -X quit 2>/dev/null

# Создать новую screen-сессию в фоне
screen -dmS gensyn bash -c '
  npm install -g yarn --force
  yarn install

  rm -rf rl-swarm
  git clone https://github.com/gensyn-ai/rl-swarm

  cd rl-swarm
  python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh

  exec bash
'
