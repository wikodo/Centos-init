function updateSSHPort() {
	logTip $FUNCNAME
	cp /etc/ssh/sshd_config /etc/ssh/sshd.bak
	while true; do
		read -p "Please enter ssh port number: " Port
		if [[ -n "$Port" ]]; then
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
	if [[ "$OS_VERSION" -eq 7 ]]; then
		firewall-cmd --zone=public --add-port=$Port/tcp --permanent
	else
		iptables -I INPUT -p tcp --dport $Port -j ACCEPT
	fi
	logSuccess "Port has updated."
}

function useKeyLogin() {
	logTip $FUNCNAME
	[ ! -d ~/.ssh ] && mkdir -p ~/.ssh/
	chmod 700 ~/.ssh/
	read -p "Please paste your public key: " publicKey
	echo $publicKey >> ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys

	read -p "Do you want to prohibit password login? [N/n for rejection]: " wantProhibitPassordLogin
	if [[ $wantProhibitPassordLogin == "N" || $wantProhibitPassordLogin == "n" ]]; then
		logSuccess "KeyLogin has set."
		return
	fi

	logSuccess "KeyLogin has set."
}

function banPasswordLogin(){
	logTip $FUNCNAME
	sed -i s/"PasswordAuthentication yes"/"PasswordAuthentication no"/g /etc/ssh/sshd_config
	sed -i s/"PermitEmptyPasswords yes"/"PermitEmptyPasswords no"/g /etc/ssh/sshd_config
	sed -i s/"UsePAM yes"/"UsePAM no"/g /etc/ssh/sshd_config
	cat >>/etc/ssh/sshd_config <<EOF
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile ~/.ssh/authorized_keys
EOF
	logSuccess "PasswordLogin has banned."
}

function useIptable() {
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
		if ((portNumber == 0)); then
			break
		elif ((portNumber <= 65535 && portNumber >= 1024)); then
			iptables -A INPUT -p tcp --dport $portNumber -j ACCEPT
		else
			echo "Ports can only be pure numbers within 1024-65535."
		fi
	done
	iptables -A INPUT -p tcp --dport 21 -j ACCEPT
	iptables -A INPUT -p tcp --dport 20 -j ACCEPT
	iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
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
	read -p "Do you want to update ssh port? [N/n for rejection]: " wantUpdateSSHPort
	if [[ $wantUpdateSSHPort != "N" && $wantUpdateSSHPort != "n" ]]; then
		updateSSHPort
	fi

	read -p "Do you want to use key login? [N/n for rejection]: " wantUseKeyLogin
	if [[ $wantUseKeyLogin != "N" && $wantUseKeyLogin != "n" ]]; then
		useKeyLogin
	fi

		read -p "Do you want to ban password login? [N/n for rejection]: " wantBanPassword
	if [[ $wantBanPassword != "N" && $wantBanPassword != "n" ]]; then
		banPasswordLogin
	fi

	read -p "Do you want to use soft to prevent cracking password? [N/n for rejection]: " wantPreventCrackingPassword
	if [[ $wantPreventCrackingPassword != "N" && $wantPreventCrackingPassword != "n" ]]; then
		preventCrackingPassword
	fi

	read -p "Do you want to use iptable? [N/n for rejection]: " wantUseIptable
	if [[ $wantUseIptable != "N" && $wantUseIptable != "n" ]]; then
		useIptable
	fi
}

main
