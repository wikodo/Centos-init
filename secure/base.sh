#!/bin/bash
function deleteOrLockUnnecessaryUsersAndGroups() {
	logTip $FUNCNAME
	userdel games
	passwd -l dbus
	passwd -l nobody
	passwd -l ftp
	passwd -l mail
	passwd -l shutdown
	passwd -l halt
	passwd -l operator
	passwd -l sync
	passwd -l adm
	passwd -l lp
	logSuccess "UnnecessaryUsersAndGroups has locked/deleted."
}

function setPrivileges() {
	logTip $FUNCNAME
	chattr +i /etc/passwd
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
	chmod -R 700 /etc/rc.d/init.d/*
	logSuccess "Privileges has set."
}

function updatePort() {
	logTip $FUNCNAME
	cp /etc/ssh/sshd_config /etc/ssh/sshd.bak
	while true; do
		read -p "Please enter ssh port number: " Port
		if [ -n "$Port" ]; then
			if ((Port <= 65535 && Port >= 1024)); then
				break
			else
				echo "Ports can only be pure numbers within 1024-65535."
			fi
		else
			Port="22"
			break
		fi
	done

	echo "Port $Port" >>/etc/ssh/sshd_config
	if [ "$OS_VERSION" -eq 7 ]; then
		firewall-cmd --zone=public --add-port=$Port/tcp --permanent
	else
		iptables -I INPUT -p tcp --dport $Port -j ACCEPT
	fi
	logSuccess "Port has updated."
}

function updateSSH() {
	logTip $FUNCNAME
	sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
	sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
	sed -i 's/X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
	cat >>/etc/ssh/sshd_config <<EOF
ChrootDirectory /home/%u
AllowTcpForwarding no
EOF
	logSuccess "SSH has updated."
}

function closeCtrlAltDel() {
	logTip $FUNCNAME
	sed -i "s/ca::ctrlaltdel:\/sbin\/shutdown -t3 -r now/#ca::ctrlaltdel:\/sbin\/shutdown -t3 -r now/" /etc/inittab
	sed -i 's/^id:5:initdefault:/id:3:initdefault:/' /etc/inittab
	logSuccess "CtrlAltDel has closed."
}

function closeIpv6() {
	logTip $FUNCNAME
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6 = 1" >>/etc/sysctl.conf
	echo 1 >/proc/sys/net/ipv6/conf/all/disable_ipv6
	echo 1 >/proc/sys/net/ipv6/conf/default/disable_ipv6
	logSuccess "Ipv6 has closed."
}

function closeSELinux() {
	logTip $FUNCNAME
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0
	logSuccess "SELinux has closed."
}

function main() {
	deleteOrLockUnnecessaryUsersAndGroups
	setPrivileges
	updatePort
	updateSSH
	closeCtrlAltDel
	closeIpv6
	closeSELinux
}

main
