#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

SSH_AUTHORIZED_KEY_FILE=$(pwd)/ansible-user.pub

if [ ! -f "${SSH_AUTHORIZED_KEY_FILE}" ]; then
    echo "File ${SSH_AUTHORIZED_KEY_FILE} does not exist, exiting."
    exit
fi

ANSIBLE_USER=ansible

if $(getent passwd ${ANSIBLE_USER}); then
    echo "User ${ANSIBLE_USER} exists, exiting."
    exit
fi

SUDO_GROUP=wheel
ANSIBLE_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

useradd -d /home/${ANSIBLE_USER} ${ANSIBLE_USER}
mkdir -p /home/${ANSIBLE_USER}/.ssh
cp ${SSH_AUTHORIZED_KEY_FILE} /home/${ANSIBLE_USER}/.ssh/authorized_keys
cp /var/lib/AccountsService/users/gnome-initial-setup /var/lib/AccountsService/users/${ANSIBLE_USER}
echo "${ANSIBLE_USER}:${ANSIBLE_PASSWORD}" | chpasswd
usermod -aG ${SUDO_GROUP} ${ANSIBLE_USER}
chown -R ${ANSIBLE_USER}:${ANSIBLE_USER} /home/${ANSIBLE_USER}/
chmod 700 /home/${ANSIBLE_USER}/.ssh
chmod 644 /home/${ANSIBLE_USER}/.ssh/authorized_keys
echo "${ANSIBLE_USER}  ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers >/dev/null
