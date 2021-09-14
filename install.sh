#!/bin/bash
#vmt (Wegare)
printf 'ctrl+c' | crontab -e > /dev/null
opkg update && opkg install unzip
cek=$(cat /etc/openwrt_r*)
if [[ $cek == *"LEDE"* ]] && [[ $cek == *"ar71xx"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/ar71xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ar71xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ar71xx
elif [[ $cek == *"LEDE"* ]] && [[ $cek == *"brcm63xx"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/brcm63xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/brcm63xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/brcm63xx
elif [[ $cek == *"LEDE"* ]] && [[ $cek == *"ramips"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/ramips.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ramips/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ramips
elif [[ $cek == *"LEDE"* ]] && [[ $cek == *"sunxi"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/sunxi.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/sunxi/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/sunxi
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"ar71xx"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/ar71xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ar71xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ar71xx
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"brcm63xx"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/brcm63xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/brcm63xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/brcm63xx
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"ramips"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/ramips.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ramips/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ramips
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"sunxi"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/sunxi.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/sunxi/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/sunxi
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"aarch64_cortex-a53"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/sunxi.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/sunxi/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/sunxi
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"mips_24kc"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/ar71xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ar71xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ar71xx
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"mipsel_24kc"* ]]; then
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/ramips.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ramips/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ramips
else
echo -e "version anda tidak terdeteksi!"
exit
fi
mkdir -p /usr/share/v2ray/
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/vmt/main/vmt.sh" -O /usr/bin/vmt
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/vmt/main/autorekonek-vmt.sh" -O /usr/bin/autorekonek-vmt
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/vmt/main/v2ray" -O /usr/bin/v2ray
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/vmt/main/v2ctl" -O /usr/bin/v2ctl
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/vmt/main/geoip.dat" -O /usr/share/v2ray/geoip.dat
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/vmt/main/geosite.dat" -O /usr/share/v2ray/geosite.dat
wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/tun2socks?raw=true" -O /usr/bin/tun2socks
chmod +x /usr/bin/tun2socks
cek2=$(opkg list-installed | grep dnsmasq-full | awk '{print $1}')
if [ $cek2 = "dnsmasq-full" ]; then
echo > /dev/null
else
opkg remove dnsmasq && opkg install dnsmasq-full
fi
opkg install resolveip ip-full ipset jshn lsof fping && opkg install *.ipk
chmod +x /usr/bin/vmt
chmod +x /usr/bin/autorekonek-vmt
chmod +x /usr/bin/v2ray
chmod +x /usr/bin/v2ctl
chmod +x /usr/share/v2ray/geoip.dat
chmod +x /usr/share/v2ray/geosite.dat
rm -r ~/*.ipk
rm -r ~/install.sh
mkdir -p ~/akun/
touch ~/akun/vmt.txt
touch ~/akun/ipmodem.txt 
sleep 2
echo "install selesai"
echo "untuk memulai tools silahkan jalankan perintah 'vmt'"
echo "silahkan reboot terlebih dahulu"


				