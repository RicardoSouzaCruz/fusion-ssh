#!/bin/bash
# ════════════════════════════════════════════════════════
#  FUSION SSH - Sistema de Licença
#  Proteção por IP/Hardware - Uso Único
# ═══════════════════════════════════════════════════════

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Arquivos de licença
LICENSE_FILE="/etc/fusion-ssh/license.key"
HW_ID_FILE="/etc/fusion-ssh/hardware.id"

# Criar diretório
mkdir -p /etc/fusion-ssh

# Gerar ID único do hardware
gerar_hardware_id() {
    local ip=$(curl -s https://api.ipify.org 2>/dev/null || echo "unknown")
    local mac=$(cat /sys/class/net/*/address 2>/dev/null | head -1 || echo "unknown")
    local hostname=$(hostname)
    local hw_string="${ip}:${mac}:${hostname}"
    local hw_hash=$(echo -n "${hw_string}" | md5sum | awk '{print $1}')
    echo "${hw_hash}"
}

# Gerar chave de licença
gerar_chave_licenca() {
    local cliente_id="$1"
    local dias_validade="$2"
    local data_exp=$(date -d "+${dias_validade} days" +%Y%m%d)
    local random=$(openssl rand -hex 8)
    local chave="FUSION-${cliente_id}-${data_exp}-${random}"
    echo "${chave}"
}

# Validar chave de licença
validar_chave() {
    local chave="$1"
    
    if [[ ! "${chave}" =~ ^FUSION-[A-Z0-9]+-[0-9]{8}-[A-Fa-f0-9]{16}$ ]]; then
        echo -e "${RED}❌ Formato de chave inválido!${NC}"
        return 1
    fi
    
    local data_exp=$(echo "${chave}" | cut -d'-' -f3)    local data_atual=$(date +%Y%m%d)
    
    if [[ "${data_exp}" -lt "${data_atual}" ]]; then
        echo -e "${RED}❌ Licença expirada em ${data_exp:0:4}-${data_exp:4:2}-${data_exp:6:2}${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Licença válida até ${data_exp:0:4}-${data_exp:4:2}-${data_exp:6:2}${NC}"
    return 0
}

# Ativar licença
ativar_licenca() {
    local chave="$1"
    
    if ! validar_chave "${chave}"; then
        return 1
    fi
    
    local hw_id=$(gerar_hardware_id)
    echo "${hw_id}" > "${HW_ID_FILE}"
    echo "${chave}" > "${LICENSE_FILE}"
    chmod 600 "${LICENSE_FILE}" "${HW_ID_FILE}"
    
    local cliente_id=$(echo "${chave}" | cut -d'-' -f2)
    local data_exp=$(echo "${chave}" | cut -d'-' -f3)
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ LICENÇA ATIVADA COM SUCESSO!         ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}👤 Cliente ID:${NC} ${cliente_id}"
    echo -e "${CYAN}📅 Válida até:${NC} ${data_exp:0:4}-${data_exp:4:2}-${data_exp:6:2}"
    echo -e "${CYAN}🔒 Hardware ID:${NC} ${hw_id}"
    echo ""
}

# Ver status da licença
status_licenca() {
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  📊 STATUS DA LICENÇA                    ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    
    if [[ -f "${LICENSE_FILE}" ]]; then
        local chave=$(cat "${LICENSE_FILE}")
        local hw_id=$(cat "${HW_ID_FILE}" 2>/dev/null)
        local cliente_id=$(echo "${chave}" | cut -d'-' -f2)
        local data_exp=$(echo "${chave}" | cut -d'-' -f3)        
        echo -e "${GREEN}✅ Status:${NC} ATIVA"
        echo -e "${CYAN}👤 Cliente:${NC} ${cliente_id}"
        echo -e "${CYAN}📅 Expiração:${NC} ${data_exp:0:4}-${data_exp:4:2}-${data_exp:6:2}"
        
        local data_atual=$(date +%Y%m%d)
        local dias_restantes=$(( (data_exp - data_atual) / 100 ))
        
        if [[ ${dias_restantes} -le 7 ]]; then
            echo -e "${RED}⏰ Dias restantes:${NC} ${dias_restantes} (RENOVAR!)"
        else
            echo -e "${YELLOW}⏰ Dias restantes:${NC} ${dias_restantes}"
        fi
    else
        echo -e "${RED}❌ Status:${NC} NÃO ATIVADA"
    fi
    echo ""
}

# Gerar chave para cliente (MODO VENDEDOR)
gerar_chave_vendedor() {
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  🎫 GERAR CHAVE DE LICENÇA               ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    
    read -p "ID do cliente (ex: JOAO001): " cliente_id
    read -p "Dias de validade (ex: 30): " dias
    
    if [[ -z "${cliente_id}" || -z "${dias}" ]]; then
        echo -e "${RED}❌ Campos obrigatórios!${NC}"
        return 1
    fi
    
    local chave=$(gerar_chave_licenca "${cliente_id}" "${dias}")
    local data_exp=$(date -d "+${dias} days" +%Y-%m-%d)
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ CHAVE GERADA COM SUCESSO!            ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}🔑 CHAVE:${NC}"
    echo -e "${CYAN}${chave}${NC}"
    echo ""
    echo -e "${CYAN}📅 Válida até:${NC} ${data_exp}"
    echo -e "${CYAN}👤 Cliente:${NC} ${cliente_id}"
    echo ""
    
    echo "${chave}|${cliente_id}|${data_exp}" >> /root/chaves_geradas.txt    echo -e "${GREEN}📝 Chave salva em /root/chaves_geradas.txt${NC}"
}

# Menu principal
menu() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
 ╔═══════════════════════════════════════════╗
 ║    FUSION SSH - Sistema de Licença v1.0   ║
 ║    Proteção por Hardware - Uso Único      ║
 ╚═══════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${YELLOW}📋 OPÇÕES:${NC}"
    echo ""
    echo -e "${GREEN}[1]${NC} Ativar Licença"
    echo -e "${GREEN}[2]${NC} Ver Status"
    echo -e "${GREEN}[3]${NC} Gerar Chave (Vendedor)"
    echo -e "${GREEN}[0]${NC} Sair"
    echo ""
}

# Script Principal
case "$1" in
    "ativar")
        if [[ -z "$2" ]]; then
            echo -e "${RED}❌ Uso: bash license.sh ativar CHAVE${NC}"
            exit 1
        fi
        ativar_licenca "$2"
        ;;
    "status")
        status_licenca
        ;;
    "gerar")
        gerar_chave_vendedor
        ;;
    *)
        menu
        read -p "Escolha uma opção: " opcao
        
        case $opcao in
            1)
                read -p "Digite a chave de licença: " chave
                ativar_licenca "${chave}"
                ;;
            2)
                status_licenca                ;;
            3)
                gerar_chave_vendedor
                ;;
            0)
                echo -e "${GREEN}👋 Até logo!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Opção inválida!${NC}"
                ;;
        esac
        ;;
esac
