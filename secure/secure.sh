#!/bin/bash
function deleteOrLockUnnecessaryUsersAndGroups() {
	logTip $FUNCNAME
	userdel news
	userdel uucp
	userdel games
	passwd -l dbus
	passwd -l vcsa
	passwd -l nobody
	passwd -l avahi
	passwd -l haldaemon
	passwd -l gopher
	passwd -l ftp
	passwd -l mailnull
	passwd -l pcap
	passwd -l mail
	passwd -l shutdown
	passwd -l halt
	passwd -l operator
	passwd -l sync
	passwd -l adm
	passwd -l lp
	groupdel adm
	groupdel lp
	groupdel news
	groupdel uucp
	groupdel games
	groupdel dip
	groupdel pppusers
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

function useKeyLogin() {
	logTip $FUNCNAME
	[ ! -d ~/.ssh ] && mkdir -p ~/.ssh/
	chmod 700 ~/.ssh/
	read -p "Please paste your public key: " publicKey
	echo $publicKey >~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys

	sed -i s/"PasswordAuthentication yes"/"PasswordAuthentication no"/g /etc/ssh/sshd_config
	sed -i s/"PermitEmptyPasswords yes"/"PermitEmptyPasswords no"/g /etc/ssh/sshd_config
	sed -i s/"UsePAM yes"/"UsePAM no"/g /etc/ssh/sshd_config
	cat >>/etc/ssh/sshd_config <<EOF
RSAAuthentication yes #RSA认证
PubkeyAuthentication yes #开启公钥验证
AuthorizedKeysFile ~/.ssh/authorized_keys #验证文件路径
EOF
	service sshd restart
	logSuccess "KeyLogin has set."
}

function configIptable() {
	logTip $FUNCNAME
	systemctl stop firewalld.servic
	systemctl disable firewalld.service
	yum -y install iptables-services
	iptables -F
	iptables -X
	iptables -Z
	# 允许本地回环接口(即运行本机访问本机)
	iptables -A INPUT -i lo -j ACCEPT
	# 允许已建立的或相关连的通行
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	#允许所有本机向外的访问
	iptables -A OUTPUT -j ACCEPT
	iptables -A INPUT -p tcp --dport 80 -j ACCEPT
	iptables -A INPUT -p tcp --dport 443 -j ACCEPT
	iptables -A INPUT -p tcp --dport $Port -j ACCEPT
	while true; do
		read -p "please input port number that you want to open , enter 0 for exit:" portNumber
		if [$portNumber == 0]; then
			break
		fi
		iptables -A INPUT -p tcp --dport $portNumber -j ACCEPT
	done
	#允许FTP服务的21和20端口
	iptables -A INPUT -p tcp --dport 21 -j ACCEPT
	iptables -A INPUT -p tcp --dport 20 -j ACCEPT
	#允许ping
	iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
	#禁止其他未允许的规则访问（注意：如果22端口未加入允许规则，SSH链接会直接断开。）
	iptables -A INPUT -j REJECT
	iptables -A FORWARD -j REJECT
	service iptables save
	systemctl enable iptables
	/sbin/service iptables restart
	logSuccess "iptable has config."
}

function preventCrackingPassword() {
	logTip $FUNCNAME
	while true; do
		read -p "please input the softName that you want to use(fail2ban/DenyHosts/exit): " softName
		case $softName in
		fail2ban)
			yum install -y fail2ban
			cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
			cat >/etc/fail2ban/jail.local <<EOF
[sshd]
logpath = %(sshd_log)s
backend = %(sshd_backend)s
filter = sshd
logpath = /var/log/secure
maxretry = 3
EOF
			echo "enabled = trueport = $Port" >>/etc/fail2ban/jail.local
			read -p "please input your email: " adminEmail
			echo "action = iptables[name=SSH, port=$Port, protocol=tcp] sendmail-whois[name=SSH, dest=root, sender=$adminEmail]"
			;;
		DenyHosts)
			yum -y install denyhosts
			cat >/etc/denyhosts.conf <<EOF
# 配置相关说明
SECURE_LOG = /var/log/secure #ssh 日志文件,系统不同,文件不相同
HOSTS_DENY = /etc/hosts.deny #控制用户登陆的文件
PURGE_DENY = #过多久后清除已经禁止的，空表示永远不解禁
BLOCK_SERVICE = sshd #禁止的服务名，如还要添加其他服务，只需添加逗号跟上相应的服务即可
DENY_THRESHOLD_INVALID = 5 #允许无效用户失败的次数
DENY_THRESHOLD_VALID = 10 #允许普通用户登陆失败的次数
DENY_THRESHOLD_ROOT = 1 #允许root登陆失败的次数
DENY_THRESHOLD_RESTRICTED = 1
WORK_DIR = /var/lib/denyhosts #运行目录
SUSPICIOUS_LOGIN_REPORT_ALLOWED_HOSTS=YES
HOSTNAME_LOOKUP=YES #是否进行域名反解析
LOCK_FILE = /var/run/denyhosts.pid #程序的进程ID
SMTP_HOST = localhost
SMTP_PORT = 25
SMTP_FROM = DenyHosts <nobody@localhost>
SMTP_SUBJECT = DenyHosts Report
AGE_RESET_VALID=5d #用户的登录失败计数会在多久以后重置为0，(h表示小时，d表示天，m表示月，w表示周，y表示年)
AGE_RESET_ROOT=25d
AGE_RESET_RESTRICTED=25d
AGE_RESET_INVALID=10d
RESET_ON_SUCCESS = yes #如果一个ip登陆成功后，失败的登陆计数是否重置为0
DAEMON_LOG = /var/log/denyhosts #自己的日志文件
DAEMON_SLEEP = 30s #当以后台方式运行时，每读一次日志文件的时间间隔。
EOF
			read -p "please input your email: " adminEmail
			echo "ADMIN_EMAIL = $adminEmail" >>/etc/denyhosts.conf
			/etc/init.d/daemon-control start
			systemctl enable daemon-control
			;;
		exit)
			break
			;;
		*)
			echo 'Input is wrong, please input again.'
			;;
		esac
	done
	logSuccess "CrackingPassword has prevented."
}

function main() {
	deleteOrLockUnnecessaryUsersAndGroups
	setPrivileges
	configIptable
	updatePort
	updateSSH
	closeCtrlAltDel
	closeIpv6
	closeSELinux
	useKeyLogin
	preventCrackingPassword
}

main
