# CentosInit.sh


[![支付宝捐助按钮](https://camo.githubusercontent.com/f4874996db5ac421925db08778d800d76d36abbc/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2545362539342541462545342542422539382545352541452539442d25453525393025393154412545362538442539302545352538412541392d677265656e2e737667)](https://cdn.jsdelivr.net/gh/Tomotoes/images/blog/alipay.png)

[![微信捐助按钮](https://camo.githubusercontent.com/26101aa838286ad0d45a6f71b25fdc6e14e7668c/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2545352542452541452545342542462541312d25453525393025393154412545362538442539302545352538412541392d677265656e2e737667)](https://cdn.jsdelivr.net/gh/Tomotoes/images/blog/wechat.png)

[中文版说明](<https://github.com/Tomotoes/Centos-init/blob/master/README.zh_CN.md>)

> A highly customized, intelligent Centos initialization script.
>

Sounds boring.

Let's try again.

**The script will not make you a 10x developer...but you might feel like one.**



## Prerequisites
- Centos7 System

- 64bit Operating System.

- `curl` or `wget` should be installed



## Install
The CentosInit Script is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

**via curl**
```sh
sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"
```

**via wget**
```sh
sh -c "$(wget https://tomotoes.com/Centos-init/install.sh -O -)"
```



## Screenshots

![screenshot](https://github.com/Tomotoes/Centos-init/blob/master/screenshot.gif)



## Usage

### Basic introduction

Script functions are divided into four categories:

1. Update
	```sh
	updateLanguage
  updateTime
	updateLanguage
	updateTime
	updateDNS
	updateYumSource
	updateHostname
	updateUlimit
	updateCoreConfig
	```

2. install
   ```sh
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
   ```

3. config
  ```sh
	configVim
	configZsh
	configGit
	configNode
	configDocker
	configNginx
	configShadowSocks
  ```

4. secure
   - base

     ```sh
     deleteOrLockUnnecessaryUsersAndGroups
     setPrivileges
     closeCtrlAltDel
     closeIpv6
     closeSELinux
     ```

- expert

  ```sh
     updateSSHPort
     useKeyLogin
     useIptable
     preventCrackingPassword
     ```

- user

  ```sh
     getUserInfo
     addUser
     joinWheelGroup
     banRootLogin
     ```



### Install separate function

If you want to install a single service`( Update | Install | Config | Secure )`

Please refer to the following example:

```sh
# Update only
ONLY_UPDATE=Y sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"

# Install and Config
ONLY_INSTALL=Y ONLY_CONFIG=Y sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"
```



### Interactive mode

You can also set the installation to interactive mode, in which you will be asked if you want to proceed with the next installation and configuration steps.

Please refer to the following example:

```sh
INTERACTIVE=Y sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"
```



## License
The Script is released under the MIT license.
