#!/bin/bash

add-apt-repository universe
apt update -y
apt install -y shadowsocks-libev
systemctl stop ss-v2ray.service
systemctl stop shadowsocks-libev
fuser -k 80/tcp
mkdir /tmp/sstmp
wget -O /tmp/sstmp/v2ray-plugin-linux-amd64-v1.3.1.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/v2ray-plugin-linux-amd64-v1.3.1.tar.gz
tar -xvf /tmp/sstmp/v2ray-plugin-linux-amd64-v1.3.1.tar.gz -C /tmp/sstmp
install -m 755 /tmp/sstmp/v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
rm -f -r /tmp/sstmp
PASSWORD=$(cat /proc/sys/kernel/random/uuid)
IPADDR=$(ip addr show |grep 'inet '|grep -v 127.0.0.1 |awk '{print $2}'| cut -d/ -f1)
ENCRYPTION=xchacha20-ietf-poly1305
rm -f /etc/shadowsocks-libev/config.json
cat << EOF > /etc/shadowsocks-libev/config.json
{
    "server":"$IPADDR",
    "server_port":"80",
    "nameserver":"1.1.1.1",
    "password":"$PASSWORD",
    "timeout":60,
    "method":"$ENCRYPTION",
    "mode": "tcp_and_udp",
    "fast_open":true,
    "reuse_port":true,
    "no_delay":true,
    "plugin": "/usr/bin/v2ray-plugin",
    "plugin_opts":"server;loglevel=none"
}
EOF
rm -f /etc/systemd/system/ss-v2ray.service
cat << EOF > /etc/systemd/system/ss-v2ray.service
[Unit]
Description=Shadowsocks + V2RAY Service
After=network.target
[Service]
Type=simple
ExecStart=ss-server -c /etc/shadowsocks-libev/config.json
[Install]
WantedBy=multi-user.target
EOF
systemctl enable ss-v2ray.service
systemctl start ss-v2ray.service
printf "\033[37;1;41mss://$(echo -n $ENCRYPTION:$PASSWORD | base64 -w 0)@$IPADDR:80/?plugin=v2ray\033[0m\n"