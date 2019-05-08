#!/bin/bash
set -o nounset
function main(){
	version=1557326115
	echo "Install the latest version(${version}) of the script ..."
	wget https://github.com/Tomotoes/Centos-init/archive/${version}.tar.gz
	tar -zxvf ${version}.tar.gz
	rm -rf ${version}.tar.gz
	SCRIPT_PATH=$(pwd)"/Centos-init-${version}"
	chmod +x $SCRIPT_PATH/main.sh
	source $SCRIPT_PATH/main.sh
}
main
