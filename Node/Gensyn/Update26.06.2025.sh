#!/bin/bash

echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/main/kuznica_logo.sh | bash
echo "*******************************************************"

# Завершаем старую screen-сессию gensyn, если она запущена
screen -S gensyn -X quit 2>/dev/null

# Запускаем новую screen-сессию в фоне с нужным набором команд
screen -dmS gensyn bash -c '
  echo "Запуск внутри screen..."
  npm install -g yarn --force
  yarn install

  rm -rf rl-swarm
  git clone https://github.com/gensyn-ai/rl-swarm
  cd rl-swarm

  python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh

  exec bash
'

# Подключаемся к созданной screen-сессии (переключаем терминал в неё)
screen -r gensyn
