#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
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
sudo n lts
n 20.18.0

CONFIG_PATH="/root/rl-swarm/hivemind_exp/configs/gpu/grpo-qwen-2.5-1.5b-deepseek-r1.yaml"
REMOTE_URL="https://raw.githubusercontent.com/blackcat-team/kuznica/main/Node/Gensyn/grpo-qwen-2.5-1.5b-deepseek-r1.yaml"

echo "[INFO] Removing old config if it exists..."
rm -f "$CONFIG_PATH"

echo "[INFO] Downloading new config from GitHub..."
curl -fsSL "$REMOTE_URL" -o "$CONFIG_PATH"

if [ $? -eq 0 ]; then
  echo "[SUCCESS] Config updated at $CONFIG_PATH"
else
  echo "[ERROR] Failed to download config from $REMOTE_URL"
  exit 1
fi
TARGET_FILE="/root/rl-swarm/hivemind_exp/runner/grpo_runner.py"
sed -i '/hivemind\.DHT/ {
  s/ensure_bootstrap_success *= *True/ensure_bootstrap_success=False/
  /ensure_bootstrap_success/! s|\(hivemind.DHT(start=True, startup_timeout=30, \)|\1ensure_bootstrap_success=False, |
}' "$TARGET_FILE"
./run_rl_swarm.sh
