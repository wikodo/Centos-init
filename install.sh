#!/bin/bash
set -o nounset
function main(){
	version=1557296573
	echo "Install the latest version(${version}) of the script ..."
	wget https://github.com/Tomotoes/Centos-init/archive/${version}.tar.gz
	tar -zxvf ${version}.tar.gz
	rm -rf ${version}.tar.gz
	cd Centos-init-${version}
	chmod +x main.sh
	./main.sh
}
main
