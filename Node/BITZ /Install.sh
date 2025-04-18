#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
}
green  "Начинаю установку ноды BITZ"
green  "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
green  "Обновление успешно завершено."
sudo apt install -y build-essential pkg-config libssl-dev clang
green  "Устанавливаю Rust, пожалуйста, подождите..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Rust.sh)
sleep 2
source "$HOME/.cargo/env"
green "Rust установлен, продалжаю установку ноды"
green  "Устанавливаем Solana CLI..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Solana_CLI) &>/dev/null
green "CLI установлен, продолжаем установку ноды"
sleep 2
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
sleep 2
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
solana-keygen new --no-passphrase
sleep 5
green "Начинаю генерацию приватного ключа..."
sleep 5
green "Ваш приватный ключ:"
cat ~/.config/solana/id.json
green  "!!!Обязательно СОХРАНИТЕ приватный ключ к себе на компьютер!!!"
sleep 20
green "Продолжаем установку ноды"
cargo install bitz
solana config set --url https://mainnetbeta-rpc.eclipse.xyz/
green "Установка ноды завершена, для продолжения выполните команду: solana address"
