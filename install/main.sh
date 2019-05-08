#!/bin/bash
function installCommonSoft() {
	logTip $FUNCNAME
	yum -y install epel-release
	yum -y groupinstall development
	yum -y install wget man bind-utils net-tools lrzsz gcc gcc-c++ make cmake libxml2-devel traceroute glibc-headers openssh-clients libtool openssl-devel openssl curl curl-devel unzip sudo ntp libaio-devel ncurses-devel autoconf automake zlib-devel python-devel
	yum -y update
	yum clean all
	yum makecache
	logSuccess "CommonSoft has installed"
}

function installGit() {
	logTip $FUNCNAME
	yum -y install git
	git config --global user.name $gitUserName
	git config --global user.email $gitUserEmail
	git config --global http.sslverify false
	git config --global https.sslverify false

	# ssh-keygen -t rsa -C "${gitUserEmail}"
	# read -p "Please input your githubUserName: " githubUserName
	# scp ~/.ssh/id_rsa.pub ${githubUserName}@github.com
	# ssh -T git@github.com

	logSuccess "Git has installed."
}

function installVim() {
	logTip $FUNCNAME
	yum -y install vim vim-enhanced
	curl -sLf https://spacevim.org/cn/install.sh | bash -s -- --install vim
	logSuccess "Vim has installed."
}

function installZsh() {
	logTip $FUNCNAME
	yum -y install zsh
	NO_INTERACTIVE=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/subtlepseudonym/oh-my-zsh/feature/install-noninteractive/tools/install.sh)"
	logSuccess "Zsh has installed."
}

function installNode() {
	logTip $FUNCNAME
	git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
	sed -i 's/plugins=.*/plugins=( git zsh-nvm )/g' ~/.zshrc
	source ~/.zshrc
	nvm install stable
	case $inChina in
	Y | y)
		npm config set registry https://registry.npm.taobao.org
		npm config set disturl https://npm.taobao.org/dist
		npm config set puppeteer_download_host https://npm.taobao.org/mirrors
		;;
	*) ;;
	esac
	logSuccess "Node has installed."
}

function installNpmPackages() {
	logTip $FUNCNAME
	npm install -g tldr pm2 nodemon
	logSuccess "tldr pm2 nodemon have installed."
}

function installPython() {
	logTip $FUNCNAME
	yum -y install https://centos7.iuscommunity.org/ius-release.rpm
	yum makecache
	yum -y install python36u
	yum -y install python36u-pip
	yum -y install python36u-devel
	ln -s /usr/local/python3.6/bin/python3 /usr/bin/python3
	pip install --upgrade pip
	logSuccess "Python has installed."

}

function installPipPackages() {
	logTip $FUNCNAME
	pip install thefuck
	logSuccess "theFuck has installed."
}

function installDocker() {
	logTip $FUNCNAME
	yum -y install docker
	service docker start
	systemctl enable docker
	docker run hello-world
	logSuccess "Docker has installed."
}

function installNginx() {
	logTip $FUNCNAME
	rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
	yum install -y nginx
	systemctl start nginx.service
	systemctl enable nginx.service
	logSuccess "Nginx has installed."
}

function installCcat() {
	logTip $FUNCNAME
	wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
	tar -zxvf linux-amd64-1.1.0.tar.gz
	mv linux-amd64-1.1.0/ccat /usr/bin/ccat
	chmod +x /usr/bin/ccat
	rm -rf linux-amd64-1.1.0{,.tar.gz}
	logSuccess "Ccat has installed."
}

function installShadowSocks() {
	logTip $FUNCNAME
	wget --no-check-certificate -O shadowsocks.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh && chmod +x shadowsocks.sh && ./shadowsocks.sh 2>&1 | tee shadowsocks.log
	/etc/init.d/shadowsocks restart
	# 安装 BBR
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
	# 查看 BBR 是否安装成功
	lsmod | grep bbr
	logSuccess "shadowsocks has installed."
}

function main() {
	installCommonSoft
	installGit
	installVim
	installZsh
	installNode
	installNpmPackages
	installPython
	installPipPackages
	installDocker
	installNginx
	installCcat
	installShadowSocks
	cat <<EOF
+-------------------------------------------------+
|               install is done                   |
+-------------------------------------------------+
EOF
}

main
