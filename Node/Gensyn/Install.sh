#!/bin/bash
echo "*******************************************************"
curl -sSL https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
sleep 3
curl -sSL https://raw.githubusercontent.com/zunxbt/installation/main/node.sh | bash
sleep 1
sudo apt install -y python3 python3-pip python3-venv git
sleep 1
git clone https://github.com/gensyn-ai/rl-swarm.git
sleep 1
cd rl-swarm
sleep 1
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install accelerate==1.7
sudo apt install -y npm
sudo npm install -g yarn
sudo npm install -g n
sudo npm install encoding pino-pretty
sudo n lts
n 20.18.0
wget https://raw.githubusercontent.com/blackcat-team/kuznica/main/Node/Gensyn/auto_restart.sh
sleep 5
chmod +x auto_restart.sh
./auto_restart.sh
