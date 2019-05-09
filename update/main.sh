function updateHostname() {
	logTip $FUNCNAME
	read -p "Please input your hostname , enter means skip: " hostname
	if [[ -z $hostname ]]; then
		return
	fi
	if [[ "$OS_VERSION" -eq 7 ]]; then
		hostnamectl --static set-hostname $hostname
	else
		echo -e "NETWORKING=yes\nHOSTNAME=$hostname" >/etc/sysconfig/network
	fi
	logSuccess "Hostname($hostname) has updated."
}

function updateLanguage() {
	logTip $FUNCNAME
	read -p "Do you want to configure Chinese for your server? [N/n for rejection]: " wantConfigChinese
	if [[ $wantConfigChinese != "N" && $wantConfigChinese != "n" ]]; then
		echo LANG=\"zh_CN.utf8\" >>/etc/sysconfig/i18n
		source /etc/sysconfig/i18n
		logSuccess "Language has updated."
	else
		logSuccess "Did not change."
	fi
}

function updateDNS() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you wan update DNS to [8.8.8.8,114,114,114,114]? [N/n for rejection]: " wantUpdateDNS
	fi
	if [[ $wantUpdateDNS == "N" || $wantUpdateDNS == "n" ]]; then
		return
	fi
	cat >/etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 114.114.114.114
EOF
	logSuccess "DNS has updated."
}

function updateYumSource() {
	logTip $FUNCNAME
	read -p "Is your server in China? [N/n for in China]: " inChina
	if [[ $inChina == "N" || $inChina == "n" ]]; then
		mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
		wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-${OS_VERSION}.repo
		wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-${OS_VERSION}.repo
		yum clean all
		yum makecache
		logSuccess "YumSource has updated."
	else
		logSuccess "It is best to use the default yum source."
	fi
}

function updateTime() {
	logTip $FUNCNAME
	read -p "Please enter all your time zones,enter means skip,input shanghai for Asia/Shanghai: " timeZone
	if [ -z $timeZone ]; then
		return
	fi
	if [[ $timeZone == "shanghai" ]]; then
		timeZone="Asia/Shanghai"
	fi
	timedatectl set-timezone $timeZone
	timedatectl set-ntp yes
	logSuccess "Time has updated."
}

function updateUlimit() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you wan update Ulimit to 65535? [N/n for rejection]: " wantUpdateUlimit
	fi
	if [[ $wantUpdateUlimit == "N" || $wantUpdateUlimit == "n" ]]; then
		return
	fi
	ulimit -HSn 65535
	echo "ulimit -SHn 65535" >>/etc/rc.local
	cat >>/etc/security/limits.conf <<EOF
* soft nofile 65535
* hard nofile 65535
* soft nproc  65535
* hard nproc  65535
EOF
	logSuccess "Ulimit has updated."
}

function updateCoreConfig() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
#关闭ipv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
#决定检查过期多久邻居条目
net.ipv4.neigh.default.gc_stale_time=120
#使用arp_announce / arp_ignore解决ARP映射问题
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.lo.arp_announce=2 # 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1 # 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1
#处理无源路由的包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
#core文件名中添加pid作为扩展名
kernel.core_uses_pid = 1 # 开启SYN洪水攻击保护
net.ipv4.tcp_syncookies = 1
#修改消息队列长度
kernel.msgmnb = 65536
kernel.msgmax = 65536
#timewait的数量，默认180000
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
#限制仅仅是为了防止简单的DoS 攻击
net.ipv4.tcp_max_orphans = 3276800
#未收到客户端确认信息的连接请求的最大值
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
#内核放弃建立连接之前发送SYNACK 包的数量
net.ipv4.tcp_synack_retries = 1
#内核放弃建立连接之前发送SYN 包的数量
net.ipv4.tcp_syn_retries = 1
#启用timewait 快速回收
net.ipv4.tcp_tw_recycle = 1
#开启重用。允许将TIME-WAIT sockets 重新用于新的TCP 连接
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
EOF
		read -p "Do you want to update the above core configuration? [N/n for rejection]: " wantUpdateCoreConfig
	fi
	if [[ $wantUpdateCoreConfig == "N" || $wantUpdateCoreConfig == "n" ]]; then
		return
	fi
	cp /etc/sysctl.conf /etc/sysctl.conf.bak
	cat >/etc/sysctl.conf <<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv4.neigh.default.gc_stale_time=120
#使用arp_announce / arp_ignore解决ARP映射问题
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.all.arp_announce=2
net.ipv4.conf.lo.arp_announce=2 # 避免放大攻击
net.ipv4.icmp_echo_ignore_broadcasts = 1 # 开启恶意icmp错误消息保护
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
#core文件名中添加pid作为扩展名
kernel.core_uses_pid = 1 # 开启SYN洪水攻击保护
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
#timewait的数量，默认180000
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
EOF
	/sbin/sysctl -p
	logSuccess "CoreConfig has updated"
}

function main() {
	if [[ $ONLY_INSTALL == "Y" || $ONLY_CONFIG == "Y" || $ONLY_SECURE == "Y" ]]; then
		return
	fi
	updateLanguage
	updateTime
	updateDNS
	updateYumSource
	updateHostname
	updateUlimit
	updateCoreConfig
	cat <<EOF
+-------------------------------------------------+
|               update is done                    |
+-------------------------------------------------+
EOF
	if [[ $ONLY_UPDATE == "Y" ]]; then
		source $SCRIPT_PATH/slogan/end.sh
	fi
}

main
