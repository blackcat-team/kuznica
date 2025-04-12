#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
}
green  "Устанавливаем необходимое ПО"
green  "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
green  "Обновление успешно завершено."
green  "Устанавливаю Rust, пожалуйста, подождите..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Rust.sh) &>/dev/null
green  "Необходимое ПО установлено, продолжаем установку ноды"
sudo apt install -y build-essential pkg-config libssl-dev clang
green  "Устанавливаем Solana CLI"
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Install_Solana_CLI) &>/dev/null
sleep 1
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
sleep 1
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
sleep 1
solana-keygen new --no-passphrase
sleep 5
green  "!!!Обязательно СОХРАНИТЕ seed фразу выше к себе на компьютер!!!"
sleep 15
cat ~/.config/solana/id.json
cargo install bitz
solana config set --url https://mainnetbeta-rpc.eclipse.xyz/
