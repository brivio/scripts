#!/bin/bash
. ~/sourcecode/deploy/runtime.sh

_system_name(){
    cat /etc/*-release|grep '^ID='|awk -F= '{printf $2}'|sed 's/"//g'
}

_system_version(){
    cat /etc/*-release|grep '^VERSION_ID='|awk -F= '{printf $2}'|sed 's/"//g'
}

# 系统启动项
_system_boot_items(){
    systemctl list-unit-files|grep enable|sort
}

_install_oh_my_zsh(){
    yum install -y git zsh zip unzip
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/brivio/oh-my-zsh/master/tools/install.sh)"
    if [[ -f ~/.zshrc ]]; then
        sed -i 's/ZSH_THEME\=\"robbyrussell\"/ZSH_THEME\=\"josh\"/g' ~/.zshrc       
        sed -i 's/# DISABLE_AUTO_UPDATE\=\"true\"/DISABLE_AUTO_UPDATE\=\"true\"/g' ~/.zshrc
    fi
}

_install_lnmp(){
    # 1、PHP
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

    php=php72w
    yum -y install $php ${php}-cli ${php}-common ${php}-devel ${php}-embedded ${php}-fpm ${php}-gd ${php}-mbstring ${php}-mysqlnd ${php}-opcache ${php}-pdo ${php}-xml

    # 2、MYSQL
    yum -y install mariadb mariadb-server
    systemctl start  mariadb
    systemctl enable  mariadb

    # 3、Apache
    yum -y install httpd httpd-manual mod_ssl mod_perl
    systemctl start  httpd
    systemctl enable  httpd
}

_init_vim(){
    if [[ ! -f ~/.vimrc ]]; then
    cat >~/.vimrc <<EOF
"设置编码
set enc=utf-8

"语法高亮
syntax on

"历史命令保存行数
set history=100

"当文件被外部改变时自动读取
set autoread

"取消自动备份及产生swp文件
set nobackup
set nowb
set noswapfile
EOF

fi
}

_init_server(){
    _install_oh_my_zsh
    _install_lnmp
}