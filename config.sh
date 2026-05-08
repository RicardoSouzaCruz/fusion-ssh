#!/bin/bash
# ════════════════════════════════════════════════════════
#  FUSION SSH - Painel de Configuração
#  Altere portas, senhas e limites facilmente
# ═══════════════════════════════════════════════════════

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "EOF"
 ╔═══════════════════════════════════════════╗
 ║    FUSION SSH - Painel de Configuração    ║
 ╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Função para mostrar menu
menu() {
    echo -e "${YELLOW}┌─────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│  📋 OPÇÕES DE CONFIGURAÇÃO              │${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${GREEN}[1]${NC} Alterar Porta SSH"
    echo -e "${GREEN}[2]${NC} Alterar Porta Dropbear"
    echo -e "${GREEN}[3]${NC} Alterar Porta Stunnel"
    echo -e "${GREEN}[4]${NC} Alterar Porta V2Ray"
    echo -e "${GREEN}[5]${NC} Alterar Porta XRay"
    echo -e "${GREEN}[6]${NC} Alterar Senha de Usuário"
    echo -e "${GREEN}[7]${NC} Alterar Limite de Conexões"
    echo -e "${GREEN}[8]${NC} Ver Configurações Atuais"
    echo -e "${GREEN}[9]${NC} Reiniciar Todos os Serviços"
    echo -e "${GREEN}[0]${NC} Sair"
    echo ""
}

# Função para alterar porta SSH
alterar_ssh() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔧 Alterar Porta SSH                   │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Nova porta SSH (padrão: 22): " nova_porta
        if [[ -z "$nova_porta" ]]; then
        nova_porta=22
    fi
    
    if [[ -f /etc/ssh/sshd_config ]]; then
        sed -i "s/^Port [0-9]*/Port $nova_porta/" /etc/ssh/sshd_config
        systemctl restart ssh
        echo -e "${GREEN}✅ Porta SSH alterada para: $nova_porta${NC}"
    else
        echo -e "${RED}❌ Arquivo de configuração SSH não encontrado${NC}"
    fi
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para alterar porta Dropbear
alterar_dropbear() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔧 Alterar Porta Dropbear              │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Nova porta Dropbear (padrão: 443): " nova_porta
    
    if [[ -z "$nova_porta" ]]; then
        nova_porta=443
    fi
    
    if [[ -f /etc/default/dropbear ]]; then
        sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$nova_porta/" /etc/default/dropbear
        systemctl restart dropbear
        echo -e "${GREEN}✅ Porta Dropbear alterada para: $nova_porta${NC}"
    else
        echo -e "${RED}❌ Arquivo de configuração Dropbear não encontrado${NC}"
    fi
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para alterar porta Stunnel
alterar_stunnel() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔧 Alterar Porta Stunnel               │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Nova porta Stunnel (padrão: 8443): " nova_porta
    
    if [[ -z "$nova_porta" ]]; then
        nova_porta=8443
    fi
        if [[ -f /etc/stunnel/stunnel.conf ]]; then
        sed -i "s/accept = [0-9]*/accept = $nova_porta/" /etc/stunnel/stunnel.conf
        systemctl restart stunnel4
        echo -e "${GREEN}✅ Porta Stunnel alterada para: $nova_porta${NC}"
    else
        echo -e "${RED}❌ Arquivo de configuração Stunnel não encontrado${NC}"
    fi
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para alterar porta V2Ray
alterar_v2ray() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔧 Alterar Porta V2Ray                 │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Nova porta V2Ray (padrão: 10000): " nova_porta
    
    if [[ -z "$nova_porta" ]]; then
        nova_porta=10000
    fi
    
    if [[ -f /usr/local/etc/v2ray/config.json ]]; then
        sed -i "s/\"port\": [0-9]*/\"port\": $nova_porta/" /usr/local/etc/v2ray/config.json
        systemctl restart v2ray
        echo -e "${GREEN}✅ Porta V2Ray alterada para: $nova_porta${NC}"
    else
        echo -e "${RED}❌ Arquivo de configuração V2Ray não encontrado${NC}"
    fi
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para alterar porta XRay
alterar_xray() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔧 Alterar Porta XRay                  │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Nova porta XRay (padrão: 10001): " nova_porta
    
    if [[ -z "$nova_porta" ]]; then
        nova_porta=10001
    fi
    
    if [[ -f /usr/local/etc/xray/config.json ]]; then
        sed -i "s/\"port\": [0-9]*/\"port\": $nova_porta/" /usr/local/etc/xray/config.json
        systemctl restart xray
        echo -e "${GREEN}✅ Porta XRay alterada para: $nova_porta${NC}"    else
        echo -e "${RED}❌ Arquivo de configuração XRay não encontrado${NC}"
    fi
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para alterar senha de usuário
alterar_senha() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔐 Alterar Senha de Usuário            │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Nome de usuário: " usuario
    read -sp "Nova senha: " senha
    echo ""
    
    if id "$usuario" &>/dev/null; then
        echo "$usuario:$senha" | chpasswd
        echo -e "${GREEN}✅ Senha do usuário '$usuario' alterada com sucesso!${NC}"
    else
        echo -e "${RED}❌ Usuário '$usuario' não encontrado${NC}"
    fi
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para alterar limite de conexões
alterar_limite() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  📊 Alterar Limite de Conexões          │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    read -p "Novo limite de conexões por usuário (padrão: 3): " limite
    
    if [[ -z "$limite" ]]; then
        limite=3
    fi
    
    sed -i "s/MaxSessions [0-9]*/MaxSessions $limite/" /etc/ssh/sshd_config
    sed -i "s/MaxStartups [0-9:]*/MaxStartups $limite:30:$((limite*2))/" /etc/ssh/sshd_config
    
    systemctl restart ssh
    echo -e "${GREEN}✅ Limite de conexões alterado para: $limite${NC}"
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Função para ver configurações atuais
ver_config() {    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  📋 Configurações Atuais                │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    
    echo -e "${YELLOW}🔌 PORTAS:${NC}"
    echo -e "  SSH: $(grep -E '^Port ' /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo '22')"
    echo -e "  Dropbear: $(grep 'DROPBEAR_PORT' /etc/default/dropbear 2>/dev/null | cut -d'=' -f2 || echo '443')"
    echo -e "  Stunnel: $(grep 'accept' /etc/stunnel/stunnel.conf 2>/dev/null | awk '{print $3}' || echo '8443')"
    echo -e "  V2Ray: $(grep -o '"port": [0-9]*' /usr/local/etc/v2ray/config.json 2>/dev/null | grep -o '[0-9]*' || echo '10000')"
    echo -e "  XRay: $(grep -o '"port": [0-9]*' /usr/local/etc/xray/config.json 2>/dev/null | grep -o '[0-9]*' || echo '10001')"
    echo ""
    
    echo -e "${YELLOW}🔒 LIMITE DE CONEXÕES:${NC}"
    echo -e "  MaxSessions: $(grep -E '^MaxSessions ' /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}' || echo '3')"
    echo ""
    
    echo -e "${YELLOW}🟢 STATUS DOS SERVIÇOS:${NC}"
    systemctl is-active ssh dropbear stunnel4 v2ray xray 2>/dev/null | while read line; do
        if [[ "$line" == "active" ]]; then
            echo -e "  ✅ $line"
        else
            echo -e "  🔴 $line"
        fi
    done
    echo ""
    
    read -p "Pressione Enter para continuar..."
}

# Função para reiniciar serviços
reiniciar_servicos() {
    echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│  🔄 Reiniciando Todos os Serviços       │${NC}"
    echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
    echo ""
    
    echo -e "${YELLOW}Reiniciando SSH...${NC}"
    systemctl restart ssh
    
    echo -e "${YELLOW}Reiniciando Dropbear...${NC}"
    systemctl restart dropbear
    
    echo -e "${YELLOW}Reiniciando Stunnel...${NC}"
    systemctl restart stunnel4
    
    echo -e "${YELLOW}Reiniciando V2Ray...${NC}"
    systemctl restart v2ray
    
    echo -e "${YELLOW}Reiniciando XRay...${NC}"    systemctl restart xray
    
    echo -e "${GREEN}✅ Todos os serviços foram reiniciados!${NC}"
    echo ""
    read -p "Pressione Enter para continuar..."
}

# Loop principal
while true; do
    menu
    read -p "Escolha uma opção: " opcao
    
    case $opcao in
        1) alterar_ssh ;;
        2) alterar_dropbear ;;
        3) alterar_stunnel ;;
        4) alterar_v2ray ;;
        5) alterar_xray ;;
        6) alterar_senha ;;
        7) alterar_limite ;;
        8) ver_config ;;
        9) reiniciar_servicos ;;
        0)
            echo -e "${GREEN}👋 Até logo!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opção inválida!${NC}"
            sleep 2
            ;;
    esac
done
