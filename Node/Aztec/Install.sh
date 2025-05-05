#!/bin/bash
echo "*******************************************************"
curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/kuznica_logo.sh | bash
echo "*******************************************************"
# Зеленый цвет сервисных сообщений echo
green() {
    echo -e "\e[32m$1\e[0m"
}
green "Устанавливаем необходимое ПО"
green "Обновляю пакеты, пожалуйста подождите....."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/main%20install) &>/dev/null
green "Обновление успешно завершено."
green "Устанавливаю Docker, пожалуйста, подождите..."
bash <(curl -s https://raw.githubusercontent.com/blackcat-team/kuznica/refs/heads/main/docker%20install) &>/dev/null
green "Docker установлен, продолжаем установку ноды"
#  Проверка наличия файла, если есть - удаляем старый
[ -f "aztec.sh" ] && rm aztec.sh
