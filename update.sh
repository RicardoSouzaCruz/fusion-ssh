#!/bin/bash
echo "🔄 Atualizando Fusion SSH..."
cd /root/fusion-ssh
git pull
chmod +x *.sh
echo "✅ Atualizado com sucesso!"
