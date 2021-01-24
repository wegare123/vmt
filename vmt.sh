#!/bin/bash
#vmt (Wegare)
clear
udp2="$(cat /root/akun/vmt.txt | grep -i udp | cut -d= -f2)" 
host2="$(cat /root/akun/vmt.txt | grep -i host | cut -d= -f2 | head -n1)" 
port2="$(cat /root/akun/vmt.txt | grep -i port | cut -d= -f2)" 
bug2="$(cat /root/akun/vmt.txt | grep -i bug | cut -d= -f2)" 
user2="$(cat /root/akun/vmt.txt | grep -i user | cut -d= -f2)" 
path2="$(cat /root/akun/vmt.txt | grep -i path | cut -d= -f2)" 
aid2="$(cat /root/akun/vmt.txt | grep -i aid | cut -d= -f2)" 
ws2="$(cat /root/akun/vmt.txt | grep -i ws | cut -d= -f2 | tail -n1)" 
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

echo "Masukkan network" 
read -p "default network: $ws2 : " ws
[ -z "${ws}" ] && ws="$ws2"

echo "host=$host
port=$port
path=$path
user=$user
bug=$bug
aid=$aid
udp=$udp
ws=$ws
#protocol=$protocol" > /root/akun/vmt.txt
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
                "alterId": $aid
              }
            ]
          }
        ]
      },
      "streamSettings": {
        "network": "$ws",
        "security": "tls",
        "tlsSettings": {
          "allowInsecure": true,
          "serverName": "$bug"
        },
          "wsSettings": { 
          "path": "/$path"
        }
      }
    }
  ]
}
EOF
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
udp="$(cat /root/akun/vmt.txt | grep -i udp | cut -d= -f2)" 
host="$(cat /root/akun/vmt.txt | grep -i host | cut -d= -f2 | head -n1)" 
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
cat <<EOF> /usr/bin/ping-vmt
#!/bin/bash
#vmt (Wegare)
while :
do
fping -c1 10.0.0.2
sleep 1
done
EOF
chmod +x /usr/bin/ping-vmt
/usr/bin/ping-vmt > /dev/null 2>&1 &
sleep 5
elif [ "${tools}" = "3" ]; then
host="$(cat /root/akun/vmt.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
#killall screen
killall -q badvpn-tun2socks v2ray ping-vmt
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
sed -i 's/exit 0/ /g' /etc/rc.local
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