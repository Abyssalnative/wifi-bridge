#!/bin/bash
apt-get install dnsmasq
apt-get install dhcpcd5
echo -e "interface eth0\nstatic ip_address=192.168.220.1/24\nstatic routers=192.168.220.0" >> /etc/dhcpcd.conf
service dhcpcd restart
echo -e "interface=eth0\nlisten-address=192.168.220.1\nbind-interfaces\nserver=8.8.8.8\ndomain-needed\nbogus-priv\ndhcp-range=192.168.220.50,192.168.220.150,12h" >> /etc/dnsmasq.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
sh -c "iptables-save > /etc/iptables.ipv4.nat"
service dnsmasq start
