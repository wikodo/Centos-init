#!/bin/bash
function main() {
	case $wantConfigSecurity in
	Y | y)
		source ./secure/secure.sh
		source ./secure/user.sh
		;;
	*) ;;
	esac
}

main
