#!/bin/bash

# Wi-FiのIPv4アドレスを取得
IP=$(/mnt/c/Windows/system32/ipconfig.exe | iconv -f CP932 -t UTF-8 | sed -e 's/\r//' | grep -A 4 'Wi-Fi' | grep 'IPv4' | cut -d ':' -f 2 | awk '{print $1}')

# .envファイルからLOCAL_IP_ADDR行を削除
sed -i".bak" -e "/LOCAL_IP_ADDR=/d" .env

# 新しいIPアドレスを.envファイルに追加
echo "LOCAL_IP_ADDR=$IP" >> .env