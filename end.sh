#!/usr/bin/env bash
function sayTip() {
  # thefuck alias zsh vim tldr->man ccat->cat
	# installed softs
}
function sayEnd() {
  logSuccess "Initialization of the system has been completed. "
  echo -e "Do you want to \e[0;31m\033[1mreboot\e[m system now? [Y/N]:\t "
  read REPLY
  case $REPLY in
  Y | y)
    echo "The system will reboot now ..."
    shutdown -r now
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
