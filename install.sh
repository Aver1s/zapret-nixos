#!/bin/bash

echo "Это кастомный скрипт для установки systemd сервиса на NixOS, репозитория https://github.com/Sergeydigl3/zapret-discord-youtube-linux"
echo "Я (автор), создал только скрипт установки"
echo "Script made by github.com/Aver1s"

sleep 2

if ! grep -q "NixOS" /etc/os-release; then
    echo "Ошибка: Этот скрипт только для NixOS"
    exit 1
fi

set -e

HOME_DIR=$(realpath "$(dirname "$0")") #~/zapret-nixos/
ZAPRET_DIR=$HOME_DIR/zapret
CONF_FILE=$ZAPRET_DIR/conf.env
ZAPRET_FLAKE=$HOME_DIR/zapret.nix

sudo chmod +x $ZAPRET_DIR/service.sh

sudo bash $ZAPRET_DIR/service.sh download-deps --default

read -p "Включить Gamefilter? [y/N] [n]: " enable_gamefilter
    if [[ "$enable_gamefilter" =~ ^[Yy1] ]]; then
        gamefilter_choice="true"
    else
        gamefilter_choice="false"
    fi

echo "Выберите сетевой интерфейс"
interfaces=("any" $(ls /sys/class/net))
    if [ ${#interfaces[@]} -eq 0 ]; then
        handle_error "Не найдены сетевые интерфейсы"
    fi
    echo "Доступные сетевые интерфейсы:"
    select chosen_interface in "${interfaces[@]}"; do
        if [ -n "$chosen_interface" ]; then
            echo "Выбран интерфейс: $chosen_interface"
            break
        fi
        echo "Неверный выбор. Попробуйте еще раз."
    done

	cat <<EOF >$CONF_FILE
interface=$chosen_interface
gamefilter=$gamefilter_choice
strategy=general_nix1.bat
EOF

echo "Настройка zapret завершена"

echo "Проверяю наличие каталога /opt..."
if [ ! -d /opt ]; then
	echo "Каталог отсутствует, создаю..."
	mkdir -p /opt
	echo "Каталог /opt создан"
else
	echo "каталог /opt существует"
fi

echo "Перенос zapret в /opt..."
sudo mv $ZAPRET_DIR /opt/zapret

echo "Перенос zapret.nix в /etc/nixos/..."
sudo mv $ZAPRET_FLAKE /etc/nixos/zapret.nix

echo "    ВНИМАНИЕ!"
echo "В данный момент zapret установлен не окончательно"
echo "Для окончательной установки вам необходимо редактировать ваш /etc/nixos/configuration.nix"
echo "Измените ваш imports модуль на:"
echo "  imports = ["
echo "    ./hardware-configuration.nix #Уже должен быть"
echo "    ./zapret.nix"
echo "  ]"
echo "А так же, вам следует добавить как зависимость модуль: networking.nftables.enable = true;"
echo "После всех выполненных действий выполните: sudo nixos-rebuild switch --flake /etc/nixos#вашхост"
