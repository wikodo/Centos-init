#!/bin/bash
function sayTip() {
	logTip 'theFuck'
	logTip 'alias'
	logTip 'change default terminal to zsh'
	logTip 'tldr->man'
	logTip 'ccat->cat'
	logTip 'shadowsocks config'
}
function sayEnd() {
  logSuccess "Initialization of the system has been completed. "
  echo -e "Do you want to \e[0;31m\033[1mreboot\e[m system now? [Y/N]:\t "
  read REPLY
  case $REPLY in
  Y | y)
    echo "The system will reboot now ..."
    reboot
    ;;
  N | n)
    echo "You must reboot later..."
    source /etc/profile
    ;;
  *)
    echo "You must input [Y/N]."
    source /etc/profile
    ;;
  esac
}

function main() {
  sayTip
  sayEnd
}

main
