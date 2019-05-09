#!/bin/bash
function deleteOrLockUnnecessaryUsersAndGroups() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
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
EOF
		read -p "Do you want to carry out the above orders?[Y/N]: " wantDeleteUsersAndGroups
	fi
	if [[ $wantDeleteUsersAndGroups == "N" || $wantDeleteUsersAndGroups == "n" ]]; then
		return
	fi
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
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
	chattr +i /etc/passwd
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
	chmod -R 700 /etc/rc.d/init.d/*
EOF
		read -p "Do you want to carry out the above orders?[Y/N]: " wantSetPrivileges
	fi
	if [[ $wantSetPrivileges == "N" || $wantSetPrivileges == "n" ]]; then
		return
	fi
	chattr +i /etc/passwd
	chattr +i /etc/shadow
	chattr +i /etc/group
	chattr +i /etc/gshadow
	chmod -R 700 /etc/rc.d/init.d/*
	logSuccess "Privileges has set."
}

function updateSSHConfig() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
UseDNS no
GSSAPIAuthentication no
X11Forwarding no
ChrootDirectory /home/%u
AllowTcpForwarding no
EOF
		read -p "Do you want to configure the above content om /etc/ssh/sshd_config?[Y/N]: " wantUpdateSSHConfig
	fi
	if [[ $wantUpdateSSHConfig == "N" || $wantUpdateSSHConfig == "n" ]]; then
		return
	fi
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
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to close CtrlAltDel?[Y/N]: " wantCloseCtrlAltDel
	fi
	if [[ $wantCloseCtrlAltDel == "N" || $wantCloseCtrlAltDel == "n" ]]; then
		return
	fi
	sed -i "s/ca::ctrlaltdel:\/sbin\/shutdown -t3 -r now/#ca::ctrlaltdel:\/sbin\/shutdown -t3 -r now/" /etc/inittab
	sed -i 's/^id:5:initdefault:/id:3:initdefault:/' /etc/inittab
	logSuccess "CtrlAltDel has closed."
}

function closeIpv6() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to close Ipv6?[Y/N]: " wantCloseIpv6
	fi
	if [[ $wantCloseIpv6 == "N" || $wantCloseIpv6 == "n" ]]; then
		return
	fi
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >>/etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6 = 1" >>/etc/sysctl.conf
	echo 1 >/proc/sys/net/ipv6/conf/all/disable_ipv6
	echo 1 >/proc/sys/net/ipv6/conf/default/disable_ipv6
	logSuccess "Ipv6 has closed."
}

function closeSELinux() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to close SELinux?[Y/N]: " wantCloseSELinux
	fi
	if [[ $wantCloseSELinux == "N" || $wantCloseSELinux == "n" ]]; then
		return
	fi
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0
	logSuccess "SELinux has closed."
}

function main() {
	deleteOrLockUnnecessaryUsersAndGroups
	setPrivileges
	updateSSHConfig
	closeCtrlAltDel
	closeIpv6
	closeSELinux
}

main
