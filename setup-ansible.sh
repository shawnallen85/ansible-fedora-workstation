#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

while true; do
    read -p "Do you wish to install Anisble? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Yes or No.";;
    esac
done

source /etc/os-release

ANSIBLE_VERSION=2.9.2-1.fc${VERSION_ID}

dnf install ansible-${ANSIBLE_VERSION} -y
