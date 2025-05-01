#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
rm -r infernet-container-starter
# Запрашиваемые парамеры
request_param() {
    read -p "$1: " param
    green $param
}
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
# Запрашиваем параметры у пользователя
green "Введите необходимые переменные для ноды:"
PRIVATE_KEY=$(request_param "Введите ваш private key (должен начинаться с 0x)")
RPC_URL=$(request_param "Введите BASE RPC URL (в формате HTTPS)")

if [[ "$PRIVATE_KEY" == 0x* ]]; then
    green "Private key введен верно"
else
    echo "Private key введен не верно, должен начинаться с 0х"
    exit 1
fi
REGISTRY_ADDRESS=0x3B1554f346DFe5c482Bb4BA31b880c1C18412170
IMAGE="ritualnetwork/infernet-node:1.4.0"

green "Начинаем переустановку ноды, подождите..."

# Клонирование репозитория (шаг 5 оф. гайда)
cd $HOME
git clone https://github.com/ritual-net/infernet-container-starter && cd infernet-container-starter
docker pull ritualnetwork/hello-world-infernet:latest
cp $HOME/infernet-container-starter/projects/hello-world/container/config.json $HOME/infernet-container-starter/deploy/config.json

# Конфигурируем ноду (Пункт 7)

#deploy/config.json
DEPLOY=$HOME/infernet-container-starter/deploy/config.json
sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$DEPLOY"
sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$DEPLOY"
sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$DEPLOY"
sed -i 's|"sleep": 3|"sleep": 5|' "$DEPLOY"
sed -i 's|"forward_stats": true|"forward_stats": false|' "$DEPLOY"
sed -i 's|"batch_size": 100|"batch_size": 1800|' "$DEPLOY"
sed -i 's|"starting_sub_id": 0|"starting_sub_id": 247300|' "$DEPLOY"
#container/config.json
CONTAINER=$HOME/infernet-container-starter/projects/hello-world/container/config.json

sed -i 's|"rpc_url": "[^"]*"|"rpc_url": "'"$RPC_URL"'"|' "$CONTAINER"
sed -i 's|"private_key": "[^"]*"|"private_key": "'"$PRIVATE_KEY"'"|' "$CONTAINER"
sed -i 's|"registry_address": "[^"]*"|"registry_address": "'"$REGISTRY_ADDRESS"'"|' "$CONTAINER"
sed -i 's|"sleep": 3|"sleep": 5|' "$CONTAINER"
sed -i 's|"forward_stats": true|"forward_stats": false|' "$CONTAINER"
sed -i 's|"batch_size": 100|"batch_size": 1800|' "$CONTAINER"
sed -i 's|"starting_sub_id": 0|"starting_sub_id": 247300|' "$CONTAINER"

#Инициализируем новую конфигурацию
sed -i 's|ritualnetwork/infernet-node:.*|ritualnetwork/infernet-node:1.4.0|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|0.0.0.0:4000:4000|0.0.0.0:4321:4000|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|8545:3000|8845:3000|' $HOME/infernet-container-starter/deploy/docker-compose.yaml
sed -i 's|container_name: infernet-anvil|container_name: infernet-anvil\n    restart: on-failure|' $HOME/infernet-container-starter/deploy/docker-compose.yaml

docker compose -f $HOME/infernet-container-starter/deploy/docker-compose.yaml up -d

cd $HOME/infernet-container-starter/deploy

docker compose down

sudo rm -rf docker-compose.yaml

wget https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/Node/Ritual/docker-compose.yaml

docker-compose up --remove-orphans -d

docker rm -fv infernet-anvil  &>/dev/null

green "Переустановка ноды успешно завершена, проверить логи ноды:  docker logs infernet-node -f --tail 100"
