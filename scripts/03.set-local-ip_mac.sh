#!/bin/bash

# en0 の IP アドレスを取得
IP=$(ifconfig en0 | grep 'inet ' | awk '{print $2}')

# .env ファイルを更新
sed -i '' -e "/LOCAL_IP_ADDR=/d" .env
echo "LOCAL_IP_ADDR=$IP" >> .env
