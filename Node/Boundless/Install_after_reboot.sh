#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
curl -L https://risczero.com/install | bash
source "/root/.bashrc"
rzup install
sudo apt install -y nvidia-container-toolkit
sudo systemctl restart docker
docker run --rm --gpus all nvidia/cuda:12.3.0-base-ubuntu22.04 nvidia-smi
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli
export PATH="$HOME/.cargo/bin:$PATH"
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc 
source ~/.bashrc 
cargo install --locked boundless-cli
cd /root/boundless/
# Запрос приватного ключа
read -p "Введите свой приватный ключ: " PRIVATE_KEY
# Путь к файлу
ENV_FILE="/root/boundless/env.base"
# Создание файла, если не существует
touch "$ENV_FILE"
# Добавление переменных
echo "export PRIVATE_KEY=\"$PRIVATE_KEY\"" >> "$ENV_FILE"
echo "export RPC_URL=\"https://mainnet.base.org\"" >> "$ENV_FILE"
echo "✅ Переменные успешно добавлены в $ENV_FILE"
source .env.base
just bento
