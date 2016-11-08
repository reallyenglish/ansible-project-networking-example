#!/bin/sh

echo "Intranet $1: gateway $2 -> $3, gre $4 -> $5"

# 192.168.101.0/24
intranet="$1"

# 172.16.1.10
gwip="$2"

# 172.16.2.10
peer="$3"

# 192.168.255.1
gresrc="$4"

# 192.168.255.2
gredst="$5"

# enable forwarding
sysctl net.inet.ip.forwarding=1
echo net.inet.ip.forwarding=1 >> /etc/sysctl.conf
cat >> /etc/pf.conf <<__EOF__
match out on em2 from $intranet to 172.16.0.0/16 nat-to $gwip
pass on em2 from $intranet to 172.16.0.0/16
__EOF__

pfctl -f /etc/pf.conf
ifconfig enc0 up
echo up > /etc/hostname.enc0
isakmpd -K
echo 'isakmpd_flags="-K"' >> /etc/rc.conf.local
echo ike esp from $gwip to $peer peer $peer main auth hmac-sha1 enc aes-128 quick auth hmac-sha1 enc aes-128 psk mypassword >> /etc/ipsec.conf
chmod 600 /etc/ipsec.conf
ipsecctl -f /etc/ipsec.conf
echo ipsec=YES >> /etc/rc.conf.local
sysctl net.inet.gre.allow=1
echo net.inet.gre.allow=1 >> /etc/sysctl.conf
ifconfig gre0 create
ifconfig gre0 $gresrc $gredst netmask 255.255.255.252 link0 up
ifconfig gre0 tunnel $gwip $peer
echo $gresrc $gredst netmask 255.255.255.252 link0 up >> /etc/hostname.gre0
echo tunnel $gwip $peer >> /etc/hostname.gre0

cat > /etc/ospfd.conf <<__EOF__
router-id $gresrc
auth-md 1 "myospfpassword"
auth-type crypt
auth-md-keyid 1
area 0.0.0.0 {
  interface gre0 { }
  interface em1 { }
}
__EOF__

chmod 600 /etc/ospfd.conf
echo ospfd_flags=\"\" >> /etc/rc.conf.local
ospfd
