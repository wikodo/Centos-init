#!/bin/bash
function logTip() {
  echo -e "\\n\033[44;37m [START]: ${1}... \033[0m\\n"
}

function logSuccess() {
  echo -e "\\n\033[42;37m [SUCCESS]: $1 \033[0m\\n"
}

function logFail() {
  echo -e "\\n\033[41;37m [FAIL]: $1 \033[0m\\n"
}

function main(){
	logSuccess 'Loaded the log file.'
}

main
