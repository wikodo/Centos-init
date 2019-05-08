#!/bin/bash
function getUser() {
  logTip $FUNCNAME
  while true; do
    read -p "Please input your userName: " userName
    if [ -z $userName ]; then
      logFail "User name cannot be empty! Please input again!"
    else
      if [[ $userName =~ ^[a-Z0-9]+$ ]]; then
        id $userName &>/dev/null
        if [ $? -ne 0 ]; then
          break
        else
          echo "This user already exists, please input again!"
        fi
      else
        echo "User name cannot contain special characters, please input again!"
      fi
    fi
  done

  while true; do
    read -s -p "Please input your password: " password
    if [ -z $password ]; then
      echo "Password cannot be empty! Please input again!"
    else
      length=$(echo $password | wc -L)
      if [ $length -ge 6 ]; then
        read -s -p "Please input the password again:" rePassword
        if [ $rePassword == $password ]; then
          break
        fi
        echo "Two input password does not match! Please input again!"
      else
        echo "The password you entered is less than 6 digits, please input again!"
      fi
    fi
  done

  logSuccess "Info has saved."
}

function addUser() {
  logTip $FUNCNAME
  useradd $userName
  echo $password | passwd --stdin $userName >/dev/null
	echo $userName ALL=(ALL) NOPASSWD: ALL >> /etc/sudoers
  logSuccess "User($userName) has created."
}

function joinWheel() {
  logTip $FUNCNAME
  usermod -G wheel $username
  echo "auth required pam_wheel.so use_uid" >>/etc/pam.d/su
  echo "SU_WHEEL_ONLY yes" >>/etc/login.defs
  logSuccess "User($userName) has join the wheel group."
}

function banRootLogin(){
  logTip $FUNCNAME
	echo -e "PermitRootLogin no\\nAllowUsers $userName"  >>/etc/ssh/sshd_config
  logSuccess "root user has banned login."
}

function main(){
	read -p "Do you want to add a new user?[Y/N]: " wantAddNewUser
	if [ $wantAddNewUser == 'Y' || $wantAddNewUser == 'y'];then
		getUser
		addUser
		joinWheel
		banRootLogin
	fi
	cat <<EOF
+-------------------------------------------------+
|               user is done                      |
+-------------------------------------------------+
EOF
}
main
