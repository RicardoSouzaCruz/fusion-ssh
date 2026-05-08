# ⚡ Fusion SSH

**Painel SSH/VPN completo e otimizado para VPS de baixo custo**

[![GitHub](https://img.shields.io/github/license/RicardoSouzaCruz/fusion-ssh)](LICENÇA)
[![Versão](https://img.shields.io/badge/version-1.0.0-blue)]()
[![Plataforma](https://img.shields.io/badge/platform-Ubuntu%20%7C%20Debian-orange)]()

---

## 📋 **Sobre o Projeto**

O **Fusion SSH** é um painel de controle completo para gerenciamento de túneis SSH, V2Ray, XRay e Stunnel. Desenvolvido para ser leve, seguro e fácil de usar, ideal para fornecedores e usuários que buscam uma solução para VPN/Proxy.

### ✨ **Funcionalidades**
- ✅ SSH + Dropbear (porta 443)
- ✅ V2Ray com WebSocket
- ✅ XRay com XTLS
- ✅ Stunnel (TLS Wrapper)
- ✅ Fail2Ban (proteção contra força bruta)
- ✅ Firewall UFW configurado
- ✅ Painel de controle via terminal
- ✅ Otimizado para VPS de 512 MB-1 GB de RAM
- ✅ Instalação automática (1 comando)

---

## 📦 **Requisitos**

- **Sistema:** Ubuntu 20.04+ ou Debian 10+
- **RAM:** Mínimo 512MB (recomendado 1GB)
- **Raiz:** Acesso sudo/root necessário
- **Portas livres:** 22, 443, 8443, 10000, 10001

---

## 🚀 **Instalação Rápida**

Execute este comando na sua VPS:

```batedor
wget https://raw.githubusercontent.com/RicardoSouzaCruz/fusion-ssh/main/Fusion-ssh && chmod +x Fusion-ssh && bash Fusion-ssh
```

**Ou, se já tiver baixado:**

```bash
bash Fusion-ssh
```

A instalação leva **3-5 minutos** e é totalmente automática!

---

## 📖 **Como Usar**

### **Após a instalação:**

1. **Acesse o painel:**
```bash
   fusion-panel
```

2. **Gerencie os serviços:**
   - Status dos serviços
   - Serviços Reiniciar
   - Ver logs
   - Informações do sistema

### **Portas Configuradas:**

| Serviço | Porta | Protocolo |
|---------|-------|-----------|
| SSH | 22 | TCP |
| Urso de gota | 443 | TCP |
| Túnel | 8443 | TCP/TLS |
| V2Ray | 10.000 | Soquete da Web |
| Raio X | 10001 | TCP/XTLS |

---

## 🛠️ **Comandos Úteis**

```batedor
# Ver status dos serviços
systemctl status ssh dropbear stunnel4 v2ray xray

# Reiniciar todos os serviços
systemctl reiniciar ssh dropbear stunnel4 v2ray xray

# Ver logs de conexão
cauda -f/var/log/auth.log

# Otimizar VPS (se já tiver o optimize.sh)
bash otimizar.sh
```

---

## 📁 **Estrutura de Arquivos**---

## 🔒 **Segurança**

- ✅ Fail2Ban ativo (bloqueia após 5 tentativas falhas)
- ✅ Firewall UFW configurado (só portas necessárias abertas)
- ✅ Senha admin gerada automaticamente
- ✅ Certificados SSL auto-assinados
- ✅ Execução apenas como raiz

---

## 🛠️ **Solução de Problemas**

### **Erro: "Executar raiz como"**
- Executar com: `sudo bash Fusion-ssh`

### **Serviço não inicia**
- Verifique os logs: `journalctl -u nome_do_servico -n 50`
- Reinicie o serviço: `systemctl reiniciar nome_do_servico`

### **Porta já em uso**
- Mude a porta no arquivo de configuração do serviço
- Ou pare o serviço conflitante

---

## 📝 **Licença**

Este projeto está sob a licença **MIT**. Sinta-se livre para usar, modificar e distribuir.

---

## 🤝 **Contribuindo**

Contribuições são bem-vindas! Sinta-se à vontade para:
- Erros de relacionamento
- Sugerir melhorias
- Solicitações de pull do Enviar

---

## 📞 **Suporte**

- **Problemas do GitHub:** [Problema com Crie Uma]https://github.com/RicardoSouzaCruz/fusion-ssh/issuesProblema com Crie Uma)
- **Documentação:** Leia este README com atenção

---

## 🙏 **Agradecimentos**

- Equipe V2Ray
- Projeto XRay
- OpenSSH
- Urso de gota
- Comunidade Linux/VPN

---

**Desenvolvido com ❤️ por RicardoSouzaCruz**

⭐ **Se esse projeto te ajudou, dê uma estrela!**
