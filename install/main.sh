#!/usr/bin/env bash
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
	read -p "Please input your gitUserName: " gitUserName
	git config --global user.name $gitUserName
	read -p "Please input your gitUserEmail: " gitUserEmail
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
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	chsh -s /bin/zsh
	logSuccess "Zsh has installed."
}

function installNode() {
	logTip $FUNCNAME
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | zsh
	source ~/.zshrc
	nvm install stable
	if [$inChina == "Y" || $inChina == "y"]; then
		npm config set registry https://registry.npm.taobao.org
		npm config set disturl https://npm.taobao.org/dist
		npm config set puppeteer_download_host https://npm.taobao.org/mirrors
	fi
	logSuccess "Node has installed."
}

function installNpmPackages() {
	npm install -g tldr pm2 nodemon
}

function installPython() {
	logTip $FUNCNAME
	yum -y install https://centos7.iuscommunity.org/ius-release.rpm
	yum makecache
	yum -y install python36u
	yum -y install python36u-pip
	yum -y install python36u-devel
	mkdir -p ~/.pip
	ln -s /usr/local/python3.6/bin/python3 /usr/bin/python3
	pip install --upgrade pip
	logSuccess "Python has installed."

}

function installPipPackages() {
	pip install thefuck
}

function installDocker() {
	logTip $FUNCNAME
	yum -y install docker
	service docker start
	sudo systemctl enable docker
	docker run hello-world
	logSuccess "Docker has installed."

}

function installNginx() {
	logTip $FUNCNAME
	sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
	sudo yum install -y nginx
	sudo systemctl start nginx.service
	sudo systemctl enable nginx.service
	logSuccess "Nginx has installed."
}

function installCcat() {
	logTip $FUNCNAME
	wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
	tar -zxvf linux-amd64-1.1.0.tar.gz
	sudo mv linux-amd64-1.1.0/ccat /usr/bin/ccat
	sudo chmod +x /usr/bin/ccat
	rm -rf linux-amd64-1.1.0{,.tar.gz}
	logSuccess "Ccat has installed."
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
	cat <<EOF
+-------------------------------------------------+
|               install is done                   |
+-------------------------------------------------+
EOF
}

main