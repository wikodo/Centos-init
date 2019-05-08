#!/bin/bash
function main() {
	source $SCRIPT_PATH/secure/base.sh
	#TODO: test
	source $SCRIPT_PATH/secure/user.sh
	source $SCRIPT_PATH/secure/expert.sh
	cat <<EOF
+-------------------------------------------------+
|               security is done                  |
+-------------------------------------------------+
EOF
}

main
