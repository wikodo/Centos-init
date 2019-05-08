#!/bin/bash
OS_VERSION=$(cat /etc/system-release | awk '{print $(NF-1)}' | awk -F"." '{print $1}')
logSuccess OS_VERSION=$OS_VERSION

ULIMIT=$(ulimit -n)
logSuccess ULIMIT=$ULIMIT

read -p "Is your server in China? [Y/N]: " inChina

