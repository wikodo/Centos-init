#!/bin/bash
function configZsh() {
	if [[ $wantInstallZSH == "N" || $wantInstallZSH == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
ZSH_THEME="agnoster"
plugins=( git z autojump zsh-autosuggestions zsh-syntax-highlighting extract )

alias vi='vim'

alias ls='ls --color=auto'
alias ll="ls --color -al"
alias grep='grep --color=auto'
alias now='date "+%Y-%m-%d %H:%M:%S"'

alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

alias mkdir='mkdir -pv'

alias size='f(){ du -sh $1* | sort -hr; }; f'

alias portopen='f(){ /sbin/iptables -I INPUT -p tcp --dport $1 -j ACCEPT; }; f'
alias portclose='f(){ /sbin/iptables -I INPUT -p tcp --dport $1 -j DROP; }; f'

alias untar='tar xvf '

alias -s html='vim'
alias -s rb='vim'
alias -s py='vim'
alias -s js='vim'
alias -s md='vim'
alias -s mjs='vim'
alias -s css='vim'
alias -s c='vim'
alias -s java='vim'
alias -s txt='vim'
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
alias -s json='vim'
alias -s go='vim'

alias cat=ccat
alias man=tldr
alias pip=pip3.6

bindkey ',' autosuggest-accept
EOF
		read -p "Do you want to configure the above options for your oh-my-zsh? [N/n for rejection]: " wantConfigZsh
	fi
	if [[ $wantConfigZsh == "N" || $wantConfigZsh == "n" ]]; then
		return
	fi
	sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

	yum -y install autojump
	yum -y install autojump-zsh

	# zsh-autosuggestions
	git clone git://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	# zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	# 配置.zshrc文件
	sed -i 's/plugins=.*/plugins=( git z autojump zsh-autosuggestions zsh-syntax-highlighting extract )/g' ~/.zshrc
	cat >>~/.zshrc <<EOF
alias vi='vim'

alias ls='ls --color=auto'
alias ll="ls --color -al"
alias grep='grep --color=auto'

# 查看当前时间
alias now='date "+%Y-%m-%d %H:%M:%S"'

alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

# 自动创建父目录
alias mkdir='mkdir -pv'

# 查看文件/目录大小
alias size='f(){ du -sh $1* | sort -hr; }; f'

# 开放端口
alias portopen='f(){ /sbin/iptables -I INPUT -p tcp --dport $1 -j ACCEPT; }; f'
# 关闭端口
alias portclose='f(){ /sbin/iptables -I INPUT -p tcp --dport $1 -j DROP; }; f'

# 解压
alias untar='tar xvf '

alias -s html='vim'   # 在命令行直接输入后缀为 html 的文件名，会在 Vim 中打开
alias -s rb='vim'     # 在命令行直接输入 ruby 文件，会在 Vim 中打开
alias -s py='vim'      # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
alias -s js='vim'
alias -s md='vim'
alias -s mjs='vim'
alias -s css='vim'
alias -s c='vim'
alias -s java='vim'
alias -s txt='vim'
alias -s gz='tar -xzvf' # 在命令行直接输入后缀为 gz 的文件名，会自动解压打开
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
alias -s json='vim'
alias -s go='vim'

alias cat=ccat
alias man=tldr
# python
alias pip=pip3.6

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Enable autosuggestions automatically.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
EOF
	logSuccess "Zsh has config."
}
function configVim() {
	if [[ $wantInstallVim == "N" || $wantInstallVim == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	# TODO: config something...
	if [[ $INTERACTIVE == "Y" ]]; then
		logFail "Vim configuration information is not currently available."
	fi
	logSuccess "Vim has config."
}

function configGit() {
	if [[ $wantInstallGit == "N" || $wantInstallGit == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	read -p "Please input your gitUserName,enter means skip: " gitUserName
	read -p "Please input your gitUserEmail,enter means skip: " gitUserEmail
	if [[ -z $gitUserName ]]; then
		echo "skip gitUserName option."
	else
		git config --global user.name $gitUserName
	fi
	if [[ -z $gitUserEmail ]]; then
		echo "skip gitUserEmail option."
	else
		git config --global user.email $gitUserEmail
	fi
	git config --global http.sslverify false
	git config --global https.sslverify false

	# ssh-keygen -t rsa -C "${gitUserEmail}"
	# read -p "Please input your githubUserName: " githubUserName
	# scp ~/.ssh/id_rsa.pub ${githubUserName}@github.com
	# ssh -T git@github.com
	logSuccess "Git has config."
}

function configNode() {
	if [[ $wantInstallNodejs == "N" || $wantInstallNodejs == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	if [[ -z $inChina ]]; then
		read -p "Is your server in China? [N/n for in China]: " inChina
	fi
	if [[ $inChina == "N" || $inChina == "n" ]]; then
		npm config set registry https://registry.npm.taobao.org
		npm config set disturl https://npm.taobao.org/dist
		npm config set puppeteer_download_host https://npm.taobao.org/mirrors
	fi
	logSuccess "npm use default config."
}

function configDocker() {
	if [[ $wantInstallDocker == "N" || $wantInstallDocker == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	# TODO: config something...
	if [[ $INTERACTIVE == "Y" ]]; then
		logFail "Docker configuration information is not currently available."
	fi
	logSuccess "Docker has config."
}

function configNginx() {
	if [[ $wantInstallNginx == "N" || $wantInstallNginx == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	# TODO: config something...
	if [[ $INTERACTIVE == "Y" ]]; then
		logFail "Nginx configuration information is not currently available."
	fi
	logSuccess "Nginx has config."
}

function configShadowSocks() {
	if [[ $wantInstallShadowSocks == "N" || $wantInstallShadowSocks == "n" ]]; then
		return
	fi
	logTip $FUNCNAME
	# TODO: config something...
	if [[ $INTERACTIVE == "Y" ]]; then
		logFail "ShadowSocks configuration information is not currently available."
	fi
	logSuccess "ShadowSocks has config."
}

function main() {
	if [[ $ONLY_SECURE == "Y" ]]; then
		return
	fi
	configVim
	configZsh
	configGit
	configNode
	configDocker
	configNginx
	configShadowSocks
	cat <<EOF
+-------------------------------------------------+
|               config is done                    |
+-------------------------------------------------+
EOF
	if [[ $ONLY_CONFIG == "Y" ]]; then
		source $SCRIPT_PATH/slogan/end.sh
	fi
}

main
