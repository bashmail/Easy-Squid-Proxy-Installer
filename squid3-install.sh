#!/bin/bash

############################################################
# Squid Proxy Installer
# Author: BashMail
# Email: support@bashmail.net
# Github: https://github.com/bashmail/squid-proxy-installer/
# Web: https://xpresservers.com
# If you need professional assistance, reach out to
# https://xpresservers.com/contact
############################################################

if [ `whoami` != root ]; then
	echo "ERROR: You need to run the script as user root or add sudo before command."
	exit 1
fi

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/sok-find-os https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/bm-find-os.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/sok-find-os

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-uninstall https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid-uninstall.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-uninstall

/usr/bin/wget -q --no-check-certificate -O /usr/local/bin/squid-add-user https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid-add-user.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-add-user

if [[ -d /etc/squid/ || -d /etc/squid3/ ]]; then
    echo "Squid Proxy already installed. If you want to reinstall, first uninstall squid proxy by running command: squid-uninstall"
    exit 1
fi

if [ ! -f /usr/local/bin/bm-find-os ]; then
    echo "/usr/local/bin/bm-find-os not found"
    exit 1
fi

BM_OS=$(/usr/local/bin/bm-find-os)

if [ $BM_OS == "ERROR" ]; then
    echo "OS NOT SUPPORTED.\n"
    echo "Contact https://xpresservers.com/contact to add support for your OS."
    exit 1;
fi

if [ $BM_OS == "ubuntu2204" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid > /dev/null 2>&1
    touch /etc/squid/passwd
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/ubuntu-2204.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    service squid restart
    systemctl enable squid
elif [ $BM_OS == "ubuntu2004" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid > /dev/null 2>&1
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    service squid restart
    systemctl enable squid
elif [ $BM_OS == "ubuntu1804" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3 > /dev/null 2>&1
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    service squid restart
    systemctl enable squid
elif [ $BM_OS == "ubuntu1604" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3 > /dev/null 2>&1
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    service squid restart
    update-rc.d squid defaults
elif [ $BM_OS == "ubuntu1404" ]; then
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3 > /dev/null 2>&1
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid3/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    service squid3 restart
    ln -s /etc/squid3 /etc/squid
    #update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid
elif [ $BM_OS == "debian8" ]; then
    # OS = Debian 8
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3 > /dev/null 2>&1
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid3/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    service squid3 restart
    update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid
elif [ $BM_OS == "debian9" ]; then
    # OS = Debian 9
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid > /dev/null 2>&1
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "debian10" ]; then
    # OS = Debian 10
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid > /dev/null 2>&1
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "debian11" ]; then
    # OS = Debian GNU/Linux 11 (bullseye)
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid > /dev/null 2>&1
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/squid.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "debian12" ]; then
    # OS = Debian GNU/Linux 12 (bookworm)
    /bin/rm -rf /etc/squid
    /usr/bin/apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid  > /dev/null 2>&1
    touch /etc/squid/passwd
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/conf.d/serverok.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/debian12.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid
    systemctl restart squid
elif [ $BM_OS == "centos7" ]; then
    yum install squid httpd-tools -y
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/squid-centos7.conf
    systemctl enable squid
    systemctl restart squid
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
elif [ "$BM_OS" == "centos8" ] || [ "$BM_OS" == "almalinux8" ] || [ "$BM_OS" == "almalinux9" ]; then
    yum install squid httpd-tools wget -y
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/squid-centos7.conf
    systemctl enable squid
    systemctl restart squid
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
elif [ "$BM_OS" == "centos8s" ]; then
    dnf install squid httpd-tools wget -y > /dev/null 2>&1
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak 
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/squid-centos7.conf
    systemctl enable squid  > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
elif [ "$BM_OS" == "centos9" ]; then
    dnf install squid httpd-tools wget -y > /dev/null 2>&1
    mv /etc/squid/squid.conf /etc/squid/squid.conf.sok
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/bashmail/Easy-Squid-Proxy-Installer/master/conf/squid-centos7.conf
    systemctl enable squid  > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    if [ -f /usr/bin/firewall-cmd ]; then
    firewall-cmd --zone=public --permanent --add-port=3128/tcp > /dev/null 2>&1
    firewall-cmd --reload > /dev/null 2>&1
    fi
fi

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${NC}"
echo -e "${GREEN}Thank you for using ServerOk Squid Proxy Installer.${NC}"
echo
echo -e "${CYAN}To create a proxy user, run command: squid-add-user${NC}"
echo -e "${CYAN}To change squid proxy port, see ${GREEN}https://xpresservers.com${NC}"
echo -e "${NC}"

