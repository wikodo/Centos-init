#!/bin/bash
function main(){
	version=1557384121
	version=1557389341
	wget https://github.com/Tomotoes/Centos-init/archive/${version}.tar.gz
	tar -zxvf ${version}.tar.gz
	rm -rf ${version}.tar.gz
	SCRIPT_PATH=$(pwd)"/Centos-init-${version}"
	chmod +x $SCRIPT_PATH/main.sh
	source $SCRIPT_PATH/main.sh
}
main
