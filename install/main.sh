#!/bin/bash
function installCommonSoft() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
epel-release wget man bind-utils net-tools lrzsz gcc gcc-c++ make cmake libxml2-devel
traceroute glibc-headers openssh-clients libtool openssl-devel openssl curl
curl-devel unzip sudo ntp libaio-devel ncurses-devel autoconf automake zlib-devel python-devel
EOF
		read -p "Do you want to install the above commonly used software? [N/n for rejection]: " wantInstallCommonSoft
	fi
	if [[ $wantInstallCommonSoft == "N" || $wantInstallCommonSoft == "n" ]]; then
		return
	fi
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
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install git? [N/n for rejection]: " wantInstallGit
	fi
	if [[ $wantInstallGit == "N" || $wantInstallGit == "n" ]]; then
		return
	fi
	yum -y install git
	logSuccess "Git has installed."
}

function installVim() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install vim? [N/n for rejection]: " wantInstallVim
		read -p "Do you want to install SpaceVim? [N/n for rejection]: " wantInstallSpaceVim
	fi
	if [[ $wantInstallVim == "N" || $wantInstallVim == "n" ]]; then
		return
	fi
	yum -y install vim vim-enhanced
	if [[ $wantInstallSpaceVim == "N" || $wantInstallSpaceVim == "n" ]]; then
		return
	fi
	curl -sLf https://spacevim.org/cn/install.sh | bash -s -- --install vim
	logSuccess "Vim has installed."
}

function installZsh() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install on-my-zsh? [N/n for rejection]: " wantInstallZSH
	fi
	if [[ $wantInstallZSH == "N" || $wantInstallZSH == "n" ]]; then
		return
	fi
	yum -y install zsh
	NO_INTERACTIVE=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/subtlepseudonym/oh-my-zsh/feature/install-noninteractive/tools/install.sh)"
	logSuccess "Zsh has installed."
}

function installNode() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install nodejs? [N/n for rejection]: " wantInstallNodejs
	fi
	if [[ $wantInstallNodejs == "N" || $wantInstallNodejs == "n" ]]; then
		return
	fi
	read -p "please input nodejs version that you want to install, enter means lastest : " nodeVersion
	if [[ -z $nodeVersion ]]; then
		nodeVersion="12.2.0"
	fi
	wget -P /usr/local/ https://nodejs.org/dist/v${nodeVersion}/node-v${nodeVersion}-linux-x64.tar.xz
	xz -d /usr/local/node-v${nodeVersion}-linux-x64.tar.xz
	tar xvf /usr/local/node-v${nodeVersion}-linux-x64.tar -C /usr/local
	ln -s /usr/local/node-v${nodeVersion}-linux-x64/bin/node /usr/local/bin/
	ln -s /usr/local/node-v${nodeVersion}-linux-x64/bin/npm /usr/local/bin/
	logSuccess "Node has installed."
}

function installNpmPackages() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		echo "tldr pm2 nodemon"
		read -p "Do you want to install the above npm packages? [N/n for rejection]: " wantInstallNpmPackages
	fi
	if [[ $wantInstallNpmPackages == "N" || $wantInstallNpmPackages == "n" ]]; then
		return
	fi
	#WARN: Npm command reject.
	npm install -g tldr pm2 nodemon
	logSuccess "tldr pm2 nodemon have installed."
}

function installPython() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install python3.6? [N/n for rejection]: " wantInstallPython
	fi
	if [[ $wantInstallPython == "N" || $wantInstallPython == "n" ]]; then
		return
	fi
	yum -y install https://centos7.iuscommunity.org/ius-release.rpm
	yum makecache
	yum -y install python36u
	yum -y install python36u-pip
	yum -y install python36u-devel
	ln -s /usr/local/python3.6/bin/python3 /usr/bin/python3
	pip3.6 install --upgrade pip
	logSuccess "Python has installed."

}

function installPipPackages() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		logTip "thefuck"
		read -p "Do you want to install the above pip packages? [N/n for rejection]: " wantInstallPipPackages
	fi
	if [[ $wantInstallPipPackages == "N" || $wantInstallPipPackages == "n" ]]; then
		return
	fi
	pip3.6 install thefuck
	logSuccess "theFuck has installed."
}

function installDocker() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install Docker? [N/n for rejection]: " wantInstallDocker
	fi
	if [[ $wantInstallDocker == "N" || $wantInstallDocker == "n" ]]; then
		return
	fi
	yum -y install docker
	service docker start
	systemctl enable docker
	docker run hello-world
	logSuccess "Docker has installed."
}

function installNginx() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install Nginx? [N/n for rejection]: " wantInstallNginx
	fi
	if [[ $wantInstallNginx == "N" || $wantInstallNginx == "n" ]]; then
		return
	fi
	rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
	yum install -y nginx
	systemctl start nginx.service
	systemctl enable nginx.service
	logSuccess "Nginx has installed."
}

function installCcat() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install CCat? [N/n for rejection]: " wantInstallCCat
	fi
	if [[ $wantInstallCCat == "N" || $wantInstallCCat == "n" ]]; then
		return
	fi
	wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
	tar -zxvf linux-amd64-1.1.0.tar.gz
	mv linux-amd64-1.1.0/ccat /usr/bin/ccat
	chmod +x /usr/bin/ccat
	rm -rf linux-amd64-1.1.0{,.tar.gz}
	logSuccess "Ccat has installed."
}

function installShadowSocks() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		read -p "Do you want to install shadowsocks? [N/n for rejection]: " wantInstallShadowSocks
	fi
	if [[ $wantInstallShadowSocks == "N" || $wantInstallShadowSocks == "n" ]]; then
		return
	fi
	wget --no-check-certificate -O shadowsocks.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks.sh && chmod +x shadowsocks.sh && ./shadowsocks.sh 2>&1 | tee shadowsocks.log
	/etc/init.d/shadowsocks restart
	wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
	logSuccess "shadowsocks has installed."
}

function main() {
	if [[ $ONLY_CONFIG == "Y" || $ONLY_SECURE == "Y" ]]; then
		return
	fi
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
	if [[ $ONLY_INSTALL == "Y" ]]; then
		source $SCRIPT_PATH/slogan/end.sh
	fi
}

main
