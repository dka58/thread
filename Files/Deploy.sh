#!/bin/bash

apt update -y
apt install -y wget tar psmisc shadowsocks-libev
systemctl stop shadowsocks-libev
fuser -k 51111/tcp
mkdir /tmp/sstmp
wget -O /tmp/sstmp/v2ray-plugin-linux-amd64.tar.gz \
https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz
tar -xvf /tmp/sstmp/v2ray-plugin-linux-amd64.tar.gz -C /tmp/sstmp
install -m 755 /tmp/sstmp/v2ray-plugin_linux_amd64 /usr/bin/v2ray
rm -rf /tmp/sstmp
IPADDR=$(ip addr show |grep 'inet '|grep -v 127.0.0.1 |awk '{print $2}'| cut -d/ -f1)
PASSWORD=$(cat /proc/sys/kernel/random/uuid)
ENCRYPTION=xchacha20-ietf-poly1305
cat << EOF > /etc/shadowsocks-libev/config.json
{
    "server":"$IPADDR",
    "server_port":"51111",
    "nameserver":"1.1.1.1",
    "password":"$PASSWORD",
    "timeout":60,
    "method":"$ENCRYPTION",
    "mode": "tcp_and_udp",
    "fast_open":true,
    "reuse_port":true,
    "no_delay":true,
    "plugin": "/usr/bin/v2ray",
    "plugin_opts":"server;loglevel=none"
}
EOF
systemctl start shadowsocks-libev
systemctl restart shadowsocks-libev
printf "\033[37;1;41mss://$(echo -n $ENCRYPTION:$PASSWORD | base64 -w 0)@$IPADDR:51111/?plugin=v2ray\033[0m\n"
