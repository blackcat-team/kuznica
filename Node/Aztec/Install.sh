#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
}
cyan() {
    echo -e "\e[36m$1\e[0m"
}
red() {
    echo -e "\e[31m$1\e[0m"
}
green "Устанавливаем необходимое ПО"
green "Обновляю пакеты, устанавливаю необходимое ПО, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
sudo apt-get install -y curl screen net-tools psmisc jq
green "Обновление успешно завершено. ПО установлено"
sleep 1

green "Устанавливаю Docker, пожалуйста, подождите..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/docker%20install) &>/dev/null
green "Docker установлен, продолжаем установку ноды"
#  Проверка наличия файла, если есть - удаляем старый
[ -f "aztec.sh" ] && rm aztec.sh

[ -d /root/.aztec/alpha-testnet ] && rm -r /root/.aztec/alpha-testnet
AZTEC_PATH=$HOME/.aztec
BIN_PATH=$AZTEC_PATH/bin
mkdir -p $BIN_PATH
green "Устанавливаю CLI Aztec..."
if [ -n "$DOCKER_CMD" ]; then
  export DOCKER_CMD="$DOCKER_CMD"
fi

curl -fsSL https://install.aztec.network | bash

if ! command -v aztec >/dev/null 2>&1; then
    cyan "Aztec CLI не найден в PATH. Добавляю для текущей сессии..."
    export PATH="$PATH:$HOME/.aztec/bin"
    
    if ! grep -Fxq 'export PATH=$PATH:$HOME/.aztec/bin' "$HOME/.bashrc"; then
        echo 'export PATH=$PATH:$HOME/.aztec/bin' >> "$HOME/.bashrc"
        green "Aztec добавлен в PATH"
    fi
fi

if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

export PATH="$PATH:$HOME/.aztec/bin"

if ! command -v aztec &> /dev/null; then
  red "ОШИБКА: Установка не удалась. Пожалуйста, проверьте логи."
  exit 1
fi
green "UPDATING AZTEC TO ALPHA-TESTNET..."
aztec-up alpha-testnet

green "CONFIGURING NODE..."
IP=$(curl -s https://api.ipify.org)
if [ -z "$IP" ]; then
    IP=$(curl -s http://checkip.amazonaws.com)
fi
if [ -z "$IP" ]; then
    IP=$(curl -s https://ifconfig.me)
fi
if [ -z "$IP" ]; then
    red "Could not determine IP address automatically"
    read -p "Please enter your VPS/WSL IP address: " IP
fi

read -p "Enter Your Sepolia Ethereum RPC URL: " L1_RPC_URL

read -p "Enter Your Sepolia Ethereum BEACON URL: " L1_CONSENSUS_URL

green "Please create a new EVM wallet, fund it with Sepolia Faucet and then provide the private key"
read -p "Enter your new evm wallet private key (with 0x prefix): " VALIDATOR_PRIVATE_KEY
read -p "Enter the wallet address associated with the private key you just provided: " ETH_ADDRESS

green "STARTING AZTEC NODE"
cat > $HOME/start_aztec_node.sh << EOL
#!/bin/bash
export PATH=\$PATH:\$HOME/.aztec/bin
aztec start --node --archiver --sequencer \\
  --network alpha-testnet \\
  --port 8080 \\
  --l1-rpc-urls $L1_RPC_URL \\
  --l1-consensus-host-urls $L1_CONSENSUS_URL \\
  --sequencer.validatorPrivateKey $VALIDATOR_PRIVATE_KEY \\
  --sequencer.coinbase $ETH_ADDRESS \\
  --p2p.p2pIp $IP \\
  --p2p.maxTxPoolSize 1000000000
EOL
chmod +x $HOME/start_aztec_node.sh
green "Создаем сервис...."
cd /etc/systemd/system/
wget https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Node/Aztec/aztec-node.service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable aztec-node.service
green "Запускаем сервис"
sudo systemctl start aztec-node.service
green "Нода успешно установлена, можете проверить логи командой 'journalctl -u aztec-node.service -f' Red желает вам удачи!"
