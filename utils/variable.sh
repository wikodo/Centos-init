#!/bin/bash
OS_VERSION=$(cat /etc/system-release | awk '{print $(NF-1)}' | awk -F"." '{print $1}')

ULIMIT=$(ulimit -n)

read -p "Is your server in China? [Y/N]:\t " inChina
