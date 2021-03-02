#!/bin/bash
#vmt (Wegare)
clear
udp2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $7}')" 
host2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $1}')" 
port2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $2}')" 
bug2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $5}')" 
user2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $4}')" 
path2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $3}')" 
aid2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $6}')" 
ws2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $8}')" 
tls2="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $9}')" 
#protocol2="$(cat /root/akun/vmt.txt | grep -i protocol | cut -d= -f2 | tail -n1)" 
echo "Inject vmess by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable auto booting & auto rekonek"
echo "5. Disable auto booting & auto rekonek"
echo "e. exit"
read -p "(default tools: 2) : " tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then

echo "Masukkan host/ip" 
read -p "default host/ip: $host2 : " host
[ -z "${host}" ] && host="$host2"

echo "Masukkan port" 
read -p "default port: $port2 : " port
[ -z "${port}" ] && port="$port2"

echo "Masukkan user id" 
read -p "default user id: $user2 : " user
[ -z "${user}" ] && user="$user2"

echo "Masukkan bug" 
read -p "default bug: $bug2 : " bug
[ -z "${bug}" ] && bug="$bug2"

read -p "ingin menggunakan port udpgw y/n " pilih
if [ "$pilih" = "y" ]; then
echo "Masukkan port udpgw" 
read -p "default udpgw: $udp2 : " udp
[ -z "${udp}" ] && udp="$udp2"
badvpn="--socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp"
elif [ "$pilih" = "Y" ]; then
echo "Masukkan port udpgw" 
read -p "default udpgw: $udp2 : " udp
[ -z "${udp}" ] && udp="$udp2"
badvpn="--socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp"
else
badvpn="--socks-server-addr 127.0.0.1:1080"
fi
#echo "Masukkan protocol" 
#read -p "default protocol: $protocol2 : " protocol
##[ -z "${protocol}" ] && protocol="$protocol2"

echo "Masukkan alterld/aid" 
read -p "default alterld/aid: $aid2 : " aid
[ -z "${aid}" ] && aid="$aid2"

echo "Masukkan path" 
read -p "default path: $path2 : " path
[ -z "${path}" ] && path="$path2"

echo "Pilih method network ws/tcp" 
read -p "default network: $ws2 : " ws
[ -z "${ws}" ] && ws="$ws2"

echo "Pilih method tls tls/none" 
read -p "default tls: $tls2 : " tls
[ -z "${tls}" ] && tls="$tls2"
if [[ -z $path ]]; then
path="-"
elif [[ -z $udp ]]; then
udp="-"
elif [[ -z $ws ]]; then
ws="-"
elif [[ -z $tls ]]; then
tls="-"
elif [[ -z $met ]]; then
met="-"
elif [[ -z $aid ]]; then
aid="-"
fi
echo "$host
$port
$path
$user
$bug
$aid
$udp
$ws
$tls" > /root/akun/vmt.txt
cat <<EOF> /root/akun/vmt.json
{
  "inbounds": [
    {
      "port": 1080,
      "listen": "127.0.0.1",
      "protocol": "socks",
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls"]
      },
      "settings": {
        "auth": "noauth",
        "udp": false
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "vmess",
      "settings": {
        "vnext": [
          {
            "address": "$host",
            "port": $port,
            "users": [
              {
                "id": "$user",
                "alterId": $aid,
                "security": "auto"
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "$ws",
        "security": "$tls",
        "tlsSettings": {
EOF
if [ "$tls" = "tls" ]; then
cat <<EOF>> /root/akun/vmt.json
          "allowInsecure": true,
          "serverName": "$bug"
        },
          "wsSettings": { 
          "path": "$path",
          "headers": {
          "Host": "$bug"
          }
        }
      }
    }
  ]
}
EOF
elif [ "$tls" = "none" ]; then
cat <<EOF>> /root/akun/vmt.json
        },
          "wsSettings": { 
          "path": "$path",
          "headers": {
          "Host": "$bug"
          }
        }
      }
    }
  ]
}
EOF
else
echo "Anda belum memilih method tls"
exit
fi
cat <<EOF> /usr/bin/gproxy-vmt
badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 $badvpn --udpgw-connection-buffer-size 65535 --udpgw-transparent-dns &
EOF
chmod +x /usr/bin/gproxy-vmt
echo "Sett Profile Sukses"
sleep 2
clear
/usr/bin/vmt
elif [ "${tools}" = "2" ]; then
ipmodem="$(route -n | grep -i 0.0.0.0 | head -n1 | awk '{print $2}')" 
echo "ipmodem=$ipmodem" > /root/akun/ipmodem.txt
udp="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $7}')" 
host="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $1}')" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)"

v2ray -c /root/akun/vmt.json &
sleep 3
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
/usr/bin/gproxy-vmt
route add 8.8.8.8 gw $route metric 0
route add 8.8.4.4 gw $route metric 0
route add $host gw $route metric 0
route add default gw 10.0.0.2 metric 0
echo "
#!/bin/bash
#vmt (Wegare)
host=$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $1}')
fping -l $host" > /usr/bin/ping-vmt
chmod +x /usr/bin/ping-vmt
/usr/bin/ping-vmt > /dev/null 2>&1 &
sleep 5
elif [ "${tools}" = "3" ]; then
host="$(cat /root/akun/vmt.txt | tr '\n' ' '  | awk '{print $1}')" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
#killall screen
killall -q badvpn-tun2socks v2ray ping-vmt fping
route del 8.8.8.8 gw "$route" metric 0 2>/dev/null
route del 8.8.4.4 gw "$route" metric 0 2>/dev/null
route del "$host" gw "$route" metric 0 2>/dev/null
ip link delete tun1 2>/dev/null
killall dnsmasq 
/etc/init.d/dnsmasq start > /dev/null
sleep 2
echo "Stop Suksess"
sleep 2
clear
/usr/bin/vmt
elif [ "${tools}" = "4" ]; then
cat <<EOF>> /etc/crontabs/root

# BEGIN AUTOREKONEKVMT
*/1 * * * *  autorekonek-vmt
# END AUTOREKONEKVMT
EOF
sed -i '/^$/d' /etc/crontabs/root 2>/dev/null
/etc/init.d/cron restart
echo "Enable Suksess"
sleep 2
clear
/usr/bin/vmt
elif [ "${tools}" = "5" ]; then
sed -i "/^# BEGIN AUTOREKONEKVMT/,/^# END AUTOREKONEKVMT/d" /etc/crontabs/root > /dev/null
/etc/init.d/cron restart
echo "Disable Suksess"
sleep 2
clear
/usr/bin/vmt
elif [ "${tools}" = "e" ]; then
clear
exit
else 
echo -e "$tools: invalid selection."
exit
fi