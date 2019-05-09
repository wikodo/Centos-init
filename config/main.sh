#!/bin/bash
function configZsh() {
	logTip $FUNCNAME
	if [[ $INTERACTIVE == "Y" ]]; then
		cat <<EOF
ZSH_THEME="agnoster"
plugins=( git autojump zsh-autosuggestions zsh-syntax-highlighting extract )
_COLUMNS=$(tput cols)
_MESSAGE=" FBI Warining "
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")

echo " "
echo -e "${spaces}\033[41;37;5m FBI WARNING \033[0m"
echo " "
_COLUMNS=$(tput cols)
_MESSAGE="Ferderal Law provides severe civil and criminal penalties for"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="the unauthorized reproduction, distribution, or exhibition of"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="copyrighted motion pictures (Title 17, United States Code,"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="Sections 501 and 508). The Federal Bureau of Investigation"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="investigates allegations of criminal copyright infringement"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="(Title 17, United States Code, Section 506)."
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"
echo " "

alias shadow='/etc/init.d/shadowsocks'
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
EOF
		read -p "Do you want to configure the above options for your oh-my-zsh?[Y/N]: " wantConfigZsh
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
	sed -i 's/plugins=.*/plugins=( git autojump zsh-autosuggestions zsh-syntax-highlighting extract )/g' ~/.zshrc
	cat >>~/.zshrc <<EOF
_COLUMNS=$(tput cols)
_MESSAGE=" FBI Warining "
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")

echo " "
echo -e "${spaces}\033[41;37;5m FBI WARNING \033[0m"
echo " "
_COLUMNS=$(tput cols)
_MESSAGE="Ferderal Law provides severe civil and criminal penalties for"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="the unauthorized reproduction, distribution, or exhibition of"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="copyrighted motion pictures (Title 17, United States Code,"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="Sections 501 and 508). The Federal Bureau of Investigation"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="investigates allegations of criminal copyright infringement"
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"

_COLUMNS=$(tput cols)
_MESSAGE="(Title 17, United States Code, Section 506)."
y=$((($_COLUMNS - ${#_MESSAGE}) / 2))
spaces=$(printf "%-${y}s" " ")
echo -e "${spaces}${_MESSAGE}"
echo " "

alias shadow='/etc/init.d/shadowsocks'
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
	logTip $FUNCNAME
	# TODO: config something...
	if [[ $INTERACTIVE == "Y" ]]; then
		logFail "Vim configuration information is not currently available."
	fi
	logSuccess "Vim has config."
}

function main() {
	if [[ $ONLY_SECURE == "Y" ]]; then
		return
	fi
	configVim
	configZsh
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
