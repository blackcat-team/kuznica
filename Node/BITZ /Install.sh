#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
}
green  "Начинаю установку ноды"
green  "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
green  "Обновление успешно завершено."
green  "Устанавливаю Rust, пожалуйста, подождите..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Rust.sh) &>/dev/null
green "Rust установлен, продалжаю установку ноды"
sudo apt install -y build-essential pkg-config libssl-dev clang
green  "Устанавливаем Solana CLI..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Solana_CLI) &>/dev/null
sleep 1
green "CLI установлен, продолжаем установку ноды"
solana-keygen new --no-passphrase
sleep 5
green "Начинаю генерацию приватного ключа..."
sleep 5
green "Ваш приватный ключ:"
cat ~/.config/solana/id.json
green  "!!!Обязательно СОХРАНИТЕ приватный ключ к себе на компьютер!!!"
sleep 20
cargo install bitz
solana config set --url https://mainnetbeta-rpc.eclipse.xyz/
