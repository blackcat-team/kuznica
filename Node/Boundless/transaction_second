#!/bin/bash

# Запрашиваем приватный ключ (в скрытом режиме)
read -s -p "Введите свой приватный ключ: " PRIVATE_KEY
echo

# Запрашиваем сумму в USDC
read -p "Введите количество USDC для депозита (например, 10 или 0.05): " USDC_AMOUNT

# Проверка: число с максимум двумя знаками после точки
if [[ ! "$USDC_AMOUNT" =~ ^[0-9]+(\.[0-9]{1,2})?$ ]]; then
    echo "❌ Ошибка: некорректный формат суммы. Допустимы только числа с не более чем двумя знаками после точки."
    exit 1
fi

# Выполнение команды
echo "▶ Выполняется команда: deposit-stake $USDC_AMOUNT"
RPC_URL="https://base-pokt.nodies.app" PRIVATE_KEY="$PRIVATE_KEY" boundless account deposit-stake "$USDC_AMOUNT"
