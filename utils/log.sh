#!/usr/bin/env bash
function logTip() {
  echo -e "\033[44;37m Start: ${1}... \033[0m\\n"
}

function logSuccess() {
  echo -e "\033[42;37m Success: $1 \033[0m\\n"
}

function logFail() {
  echo -e "\033[41;37m Fail: $1 \033[0m\\n"
}

function main() {
  OS_VERSION=$(cat /etc/system-release | awk '{print $(NF-1)}' | awk -F"." '{print $1}')
  ULIMIT=$(ulimit -n)
	read -p "Is your server in China? [Y/N]:\t " inChina
}
main
