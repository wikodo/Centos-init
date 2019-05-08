#!/bin/bash
function main() {
	case $wantConfigSecurity in
	Y | y)
		source $SCRIPT_PATH/secure/secure.sh
		source $SCRIPT_PATH/secure/user.sh
		;;
	*) ;;
	esac
	cat <<EOF
+-------------------------------------------------+
|               security is done                  |
+-------------------------------------------------+
EOF
}

main
