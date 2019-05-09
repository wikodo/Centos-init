# CentosInit.sh


[![支付宝捐助按钮](https://camo.githubusercontent.com/f4874996db5ac421925db08778d800d76d36abbc/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2545362539342541462545342542422539382545352541452539442d25453525393025393154412545362538442539302545352538412541392d677265656e2e737667)](https://cdn.jsdelivr.net/gh/Tomotoes/images/blog/alipay.png)

[![微信捐助按钮](https://camo.githubusercontent.com/26101aa838286ad0d45a6f71b25fdc6e14e7668c/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2545352542452541452545342542462541312d25453525393025393154412545362538442539302545352538412541392d677265656e2e737667)](https://cdn.jsdelivr.net/gh/Tomotoes/images/blog/wechat.png)

[English Version](<https://github.com/Tomotoes/Centos-init/blob/master/README.md>)

> 一个高度自定义,智能的Centos初始化脚本。
>

听起来有些无聊，让我们开始吧。



## 必备条件
- Centos7 系统

- 64 位操作系统

- `curl` 或 `wget` 可以使用



## 安装
此脚本可以用以下两种方式安装：

**通过 curl**

```sh
sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"
```

**通过 wget**
```sh
sh -c "$(wget https://tomotoes.com/Centos-init/install.sh -O -)"
```



## 截图

![screenshot](https://github.com/Tomotoes/Centos-init/blob/master/screenshot.gif)



## 用法

### 基本介绍

脚本功能一共分为四大类:

1. 初始化配置（update）
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

2. 安装常用软件（install）
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

3. 配置安装后的软件（config）
  ```sh
	configVim
	configZsh
	configGit
	configNode
	configDocker
	configNginx
	configShadowSocks
  ```

4. 必要的安全配置（secure）
   - 基础项

     ```sh
     deleteOrLockUnnecessaryUsersAndGroups
     setPrivileges
     closeCtrlAltDel
     closeIpv6
     closeSELinux
     ```

- 高阶项

  ```sh
     updateSSHPort
     useKeyLogin
     useIptable
     preventCrackingPassword
  ```

- 用户相关项

  ```sh
     getUserInfo
     addUser
     joinWheelGroup
     banRootLogin
  ```



### 单独功能安装

如果你想安装某一种功能`( Update | Install | Config | Secure )`

请参考以下案列:

```sh
# 在安装命令前设置 ONLY_UPDATE=Y 即可只安装 update 服务
ONLY_UPDATE=Y sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"

# Install and Config
ONLY_INSTALL=Y ONLY_CONFIG=Y sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"
```



### 交互模式

你也设置设置交互模式，在交互模式下，可高达自定义化你想使用的功能。

每执行完一项功能，都会询问你下一步。



使用功能的方法如下:

```sh
# 在安装命令前设置 INTERACTIVE=Y
INTERACTIVE=Y sh -c "$(curl -fsSL https://tomotoes.com/Centos-init/install.sh)"
```



## 协议
此项目基于 `MIT` 协议。
