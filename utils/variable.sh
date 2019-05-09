#!/bin/bash
OS_VERSION=$(cat /etc/system-release | awk '{print $(NF-1)}' | awk -F"." '{print $1}')
logSuccess OS_VERSION=$OS_VERSION

ULIMIT=$(ulimit -n)
logSuccess ULIMIT=$ULIMIT

read -p "Do you want to use interactive mode?[Y/N]: " INTERACTIVE

if [[ $INTERACTIVE == "Y" || $INTERACTIVE == "y" ]]; then
	INTERACTIVE="Y"
fi
