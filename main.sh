#!/bin/bash
# Description: The script can quickly initialize Centos.
#--------------------------------------------------------------|
#   @Program    : Centos-init.sh                               |
#   @Author     : SimonMa   <simon@tomotoes.com>               |
#   @Date       : 2019-05-07                                   |
#--------------------------------------------------------------|

set -o nounset

function main(){
  source ./slogan/welcome.sh
  source ./utils/main.sh
  source ./check/main.sh
  source ./update/main.sh
  source ./install/main.sh
  source ./config/main.sh
  source ./secure/main.sh
  source ./slogan/end.sh
}

main
