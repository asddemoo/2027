#!/bin/bash

hostnamectl set-hostname hq-cli.demo.prof

apt-get update && apt-get install -y chrony tzdata
apt-get install sshpass

        
# Настрока часового пояса
timedatectl set-timezone Asia/Krasnoyarsk


systemctl enable --now chronyd
        systemctl restart chronyd
apt-get update install -y yandex-browser-stable


# Монтирование RAID 
mkdir /mnt/nfs

# Файл options
cat >> /etc/fstab <<EOF
192.168.100.2:/raid/nfs /mnt/nfs nfs rw 0 0
EOF
mount -a
ls /mnt/nfs

# Создание пользователя sshuser с UID 2027 (МЕНЯЙТЕ ИМЯ И Т.Д В ЗАВИСИМОСТИ ОТ ЗАДАНИЯ)
useradd -u 2222 -m master

# Установка пароля P@ssw0rd без подтверждения
echo "sshuser:P@ssw0rd" | chpasswd

# Добавление в группу wheel
gpasswd -a master wheel

# Настройка sudo без пароля
echo "sshuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Настройка SSH
sed -i 's/#Port 22/Port 2222/' /etc/openssh/sshd_config
sed -i 's/#PermitRootLogin without-password/PermitRootLogin no/' /etc/openssh/sshd_config
echo "AllowUsers master" >> /etc/openssh/sshd_config
echo "MaxAuthTries 2" >> /etc/openssh/sshd_config
echo "Banner /etc/openssh/banner" >> /etc/openssh/sshd_config

# Создание баннера
echo "Authorized access only" > /etc/openssh/banner

# Перезапуск SSH
systemctl restart sshd

echo "Настройка завершена:"
echo "- Пользователь: master (пароль: P@ssw0rd)"
echo "- SSH порт: 2222"
echo "- Root-логин запрещен"
echo "- Баннер создан"

cat >> /etc/hosts <<EOF
172.16.1.1 web.demo.prof
172.16.2.1 docker.demo.prof
192.168.100.2 hq-srv.demo.prof
EOF

apt-get install -y yandex-browser-stable
