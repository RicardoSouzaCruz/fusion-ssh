# 🚀 Guia de Deploy - Fusion SSH

Guia completo para implantação do Fusion SSH em sua VPS.

---

## 📋 **Pré-requisitos**

- VPS com Ubuntu 20.04+ ou Debian 10+
- 512MB RAM mínimo (1GB recomendado)
- Acesso root/SSH
- Conexão com internet

---

## 📥 **PASSO 1: Baixar o Projeto**

```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar Git
apt install git -y

# Baixar o Fusion SSH
cd /root
git clone https://github.com/RicardoSouzaCruz/fusion-ssh.git
cd fusion-ssh

# Tornar scripts executáveis
chmod +x *.sh
```

---

## 🔧 **PASSO 2: Executar Instalação**

```bash
# Rodar instalador principal
bash Fusion-ssh
```

**Aguarde 3-5 minutos** até ver a mensagem de conclusão.

**Anote as informações exibidas:**
- ✅ Usuário admin
- ✅ Senha gerada
- ✅ Portas configuradas

---
## 🤖 **PASSO 3: Configurar Bot Telegram (Opcional)**

### **3.1 Criar Bot no Telegram:**

1. Abra o Telegram
2. Busque por **@BotFather**
3. Envie o comando: `/newbot`
4. Escolha um nome: `Fusion SSH Bot`
5. Escolha username: `fusion_ssh_bot` (deve terminar em "bot")
6. **Copie o TOKEN** que o BotFather vai te enviar

### **3.2 Descobrir seu Chat ID:**

1. Busque por **@userinfobot**
2. Envie `/start`
3. **Copie seu ID** (número tipo: 123456789)

### **3.3 Editar o Script:**

```bash
# Abrir arquivo
nano bot-telegram.sh

# Alterar estas linhas:
BOT_TOKEN="1234567890:ABCdefGHIjklMNOpqrsTUVwxyz"  # Cole seu token
ADMIN_ID="123456789"  # Cole seu Chat ID

# Salvar: Ctrl+O → Enter → Ctrl+X
```

### **3.4 Iniciar o Bot:**

```bash
# Rodar em segundo plano
nohup bash bot-telegram.sh &

# Ou usar screen (recomendado)
apt install screen -y
screen -S bot
bash bot-telegram.sh
# Ctrl+A+D para sair (o bot continua rodando)
```

---

## ✅ **PASSO 4: Verificar Instalação**

```bash
# Ver se todos os serviços estão ativossystemctl status ssh dropbear stunnel4 v2ray xray

# Ver portas abertas
netstat -tlnp

# Acessar painel
fusion-panel
```

---

##  **TESTES RÁPIDOS**

### **Testar SSH:**
```bash
ssh fusion@SEU_IP -p 22
```

### **Testar Dropbear:**
```bash
ssh fusion@SEU_IP -p 443
```

### **Testar Stunnel:**
```bash
openssl s_client -connect SEU_IP:8443
```

### **Testar V2Ray:**
Use um cliente V2Ray (V2RayNG, Shadowrocket) com:
- Endereço: SEU_IP
- Porta: 10000
- Path: /fusion-ws
- Network: WebSocket

---

## 🔒 **DICAS DE SEGURANÇA**

### **1. Alterar portas padrão:**
```bash
bash config.sh
# Escolha a opção desejada
```

### **2. Configurar Firewall:**
```bash
# O script já configura automaticamente
ufw status
```
### **3. Atualizar regularmente:**
```bash
# Atualizar sistema
apt update && apt upgrade -y

# Atualizar Fusion SSH
cd /root/fusion-ssh
git pull
```

### **4. Backup das configs:**
```bash
# Criar backup
tar czf /root/backup-fusion-$(date +%F).tar.gz \
  /etc/stunnel \
  /usr/local/etc/v2ray \
  /usr/local/etc/xray \
  /etc/default/dropbear

# Baixar backup para seu PC
scp root@SEU_IP:/root/backup-fusion-*.tar.gz /local/
```

---

## 🛠️ **SOLUÇÃO DE PROBLEMAS**

### **Erro: "Port already in use"**
```bash
# Ver o que está usando a porta
netstat -tlnp | grep :PORTA

# Matar processo
kill -9 PID
```

### **Serviço não inicia:**
```bash
# Ver logs
journalctl -u nome_servico -n 50

# Reiniciar
systemctl restart nome_servico
```

### **Bot Telegram não responde:**
```bash
# Verificar se está rodando
ps aux | grep bot-telegram
# Reiniciar
pkill -f bot-telegram
bash bot-telegram.sh &
```

### **Esqueci a senha admin:**
```bash
# Resetar senha
passwd fusion
# Digite nova senha
```

---

## 📊 **COMANDOS ÚTEIS**

```bash
# Ver usuários conectados
who

# Ver logs de autenticação
tail -f /var/log/auth.log

# Ver uso de RAM/CPU
htop

# Ver espaço em disco
df -h

# Reiniciar todos serviços
systemctl restart ssh dropbear stunnel4 v2ray xray

# Parar bot
pkill -f bot-telegram

# Iniciar bot
bash bot-telegram.sh &
```

---

## 🎓 **PRÓXIMOS PASSOS**

1. ✅ **Configurar Domínio** (opcional)
   - Aponte um domínio para o IP da VPS
   - Configure SSL válido no Stunnel

2. ✅ **Painel Web** (futuro)
   - Desenvolver interface web   - Integração com pagamentos

3. ✅ **Monitoramento**
   - Instalar Uptime Kuma
   - Configurar alertas

---

## 📞 **SUPORTE**

- 📖 Leia o README.md
- 🐛 Reporte bugs: [GitHub Issues](https://github.com/RicardoSouzaCruz/fusion-ssh/issues)
- 💬 Comunidade: Em breve

---

**Desenvolvido com ❤️ por RicardoSouzaCruz**

⭐ **Se este guia te ajudou, dê uma estrela no repositório!**
