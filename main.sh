#!/bin/bash
# Description: The script can quickly initialize Centos.
#--------------------------------------------------------------|
#   @Program    : Centos-init.sh                               |
#   @Author     : SimonMa   <simon@tomotoes.com>               |
#   @Date       : 2019-05-07                                   |
#--------------------------------------------------------------|

function main(){
  source $SCRIPT_PATH/slogan/welcome.sh
  source $SCRIPT_PATH/utils/main.sh
  source $SCRIPT_PATH/check/main.sh

  source $SCRIPT_PATH/update/main.sh
  source $SCRIPT_PATH/install/main.sh
  source $SCRIPT_PATH/config/main.sh
  source $SCRIPT_PATH/secure/main.sh

  source $SCRIPT_PATH/slogan/end.sh
}

main
