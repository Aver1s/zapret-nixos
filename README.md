# 🚀 zapret-nixos 🚀

[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue?logo=nixos&logoColor=white)](https://nixos.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Systemd](https://img.shields.io/badge/Systemd-Yes-green)](https://systemd.io)

## 📖 Информация о проекте 📖

Этот **Форк** Основан на:

 - [Sergeydigl3/zapret-discord-youtube-linux](https://github.com/Sergeydigl3/zapret-discord-youtube-linux)

 - [bol-van/zapret](https://github.com/bol-van/zapret)

 - Стратегиях от Flowseal [Flowseal/zapret-discord-youtube](https://github.com/Flowseal/zapret-discord-youtube)

Изменения в этом форке:

 - Адаптация для NixOS

 - Готовый systemd сервис через Nix модуль

 - Установка в /opt/zapret (стандарт FHS)

  Проект создан как адаптация для NixOS, всё достаточно минималистично и просто, иными словами для ленивых. Я **НЕ** гарантирую 100% работоспособность программы на вашей системе.

  Я создал только скрипт установки и .nix файл. Оригинальный код распространяется под лицензией оригинальных авторов. 
    Данная адаптация — [MIT](https://github.com/Flowseal/zapret-discord-youtube/blob/main/LICENSE.txt) License.

Полезные ссылки:

 - Оригинальный проект [Flowseal/zapret-discord-youtube](https://github.com/Flowseal/zapret-discord-youtube)
    
 - [Обсуждения и вопросы](https://github.com/Aver1s/zapret-nixos/discussions)

## ⚡ Быстрая установка ⚡

```bash
# 1. Клонируйте репозиторий
git clone https://github.com/Aver1s/zapret-nixos.git && cd zapret-nixos
```
```bash
# 2. Запустите установку
sudo ./install.sh
```
```bash
# 3. Добавьте в конфигурацию NixOS
# Отредактируйте /etc/nixos/configuration.nix
# Добавьте в свой imorts модуль "./zapret.nix"
{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix      # Уже должно быть
      ./zapret.nix                      # Добавляем
    ];
###
  networking.nftables.enable = true;    # Зависимость zapret, обязательно
}
```
```bash
# 4. Примените изменения
sudo nixos-rebuild switch
```
```bash
# Проверить статус
systemctl status zapret.service --no-pager

```

## 🗑️ Удаление
```bash
sudo systemctl stop zapret
sudo systemctl disable zapret
sudo rm -rf /opt/zapret
sudo rm /etc/nixos/zapret.nix
# Удалите строку '  ./zapret.nix' из imports в configuration.nix
sudo nixos-rebuild switch
```

