#!/bin/bash
OS_VERSION=$(cat /etc/system-release | awk '{print $(NF-1)}' | awk -F"." '{print $1}')
logSuccess OS_VERSION=$OS_VERSION

ULIMIT=$(ulimit -n)
logSuccess ULIMIT=$ULIMIT

if [[ -z $INTERACTIVE || $INTERACTIVE != "Y" ]]; then
	read -p "Do you want to use interactive mode? [N/n for rejection]: " INTERACTIVE

	if [[ $INTERACTIVE != "N" && $INTERACTIVE != "n" ]]; then
		INTERACTIVE="Y"
	fi
fi
