#!/bin/bash
tar czf /root/backup-fusion-$(date +%F).tar.gz \
  /etc/stunnel /usr/local/etc/v2ray /usr/local/etc/xray
echo "✅ Backup criado!"
