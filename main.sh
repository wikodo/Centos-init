#!/usr/bin/env bash
# Description: The script can quickly initialize Centos.
#--------------------------------------------------------------|
#   @Program    : Centos-init.sh                               |
#   @Version    : 1.0                                          |
#   @Author    : SimonMa   <simon@tomotoes.com>                |
#   @Date       : 2019-05-07                                   |
#--------------------------------------------------------------|

set -o nounset

function main(){
	source ./download.sh
  source ./welcome.sh
  source ./tool.sh
  source ./check.sh
  source ./init.sh
  source ./install.sh
  source ./config.sh
  source ./secure.sh
	# source ./user.sh
  source ./end.sh
}

main
