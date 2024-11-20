#!/bin/bash

# eth0 の IP アドレスを取得
IP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1)

# .env ファイルを更新
sed -i'.bak' -e "/LOCAL_IP_ADDR=/d" .env
echo "LOCAL_IP_ADDR=$IP" >> .env