#!/bin/bash

# Запрос приватного ключа
read -p "Введите свой приватный ключ: " PRIVATE_KEY

# Команда с подстановкой приватного ключа
RPC_URL="https://base-pokt.nodies.app"

echo "▶ Выполняется команда с заданным приватным ключом..."

RPC_URL="$RPC_URL" PRIVATE_KEY="$PRIVATE_KEY" boundless account deposit 0.00001
