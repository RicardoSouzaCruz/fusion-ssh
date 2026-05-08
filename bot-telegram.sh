#!/bin/bash
# ════════════════════════════════════════════════════════
#  FUSION SSH - Bot Telegram
#  Automação completa via Telegram
# ═══════════════════════════════════════════════════════

# CONFIGURAÇÕES - ALTERE AQUI!
BOT_TOKEN="SEU_BOT_TOKEN_AQUI"
ADMIN_ID="SEU_CHAT_ID_AQUI"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# URL da API do Telegram
API_URL="https://api.telegram.org/bot${BOT_TOKEN}"

# Função para enviar mensagem
enviar_mensagem() {
    local chat_id="$1"
    local texto="$2"
    curl -s -X POST "${API_URL}/sendMessage" \
        -d chat_id="${chat_id}" \
        -d text="${texto}" \
        -d parse_mode="Markdown"
}

# Função para criar usuário SSH
criar_usuario() {
    local usuario="$1"
    local senha="$2"
    local dias="$3"
    
    # Criar usuário
    useradd -m -s /bin/bash "${usuario}" 2>/dev/null
    echo "${usuario}:${senha}" | chpasswd
    
    # Definir expiração
    local data_exp=$(date -d "+${dias} days" +%Y-%m-%d)
    chage -E "${data_exp}" "${usuario}"
    
    echo -e "${GREEN}✅ Usuário ${usuario} criado com sucesso!${NC}"
    echo "Senha: ${senha}"
    echo "Expira em: ${data_exp}"
}

# Função para renovar usuáriorenovar_usuario() {
    local usuario="$1"
    local dias="$2"
    
    local data_atual=$(date +%Y-%m-%d)
    local data_exp=$(date -d "+${dias} days" +%Y-%m-%d)
    
    chage -E "${data_exp}" "${usuario}"
    
    echo -e "${GREEN}✅ Usuário ${usuario} renovado por ${dias} dias!${NC}"
    echo "Nova expiração: ${data_exp}"
}

# Função para listar usuários
listar_usuarios() {
    echo -e "${CYAN}📋 USUÁRIOS ATIVOS:${NC}"
    echo ""
    
    for user in $(cut -f1 -d: /etc/passwd | grep -E '^(fusion|user|cliente)'); do
        local exp=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2)
        echo "👤 ${user} - Exp: ${exp}"
    done
}

# Função para remover usuário
remover_usuario() {
    local usuario="$1"
    
    userdel -r "${usuario}" 2>/dev/null
    echo -e "${GREEN}✅ Usuário ${usuario} removido!${NC}"
}

# Função para ver status do sistema
status_sistema() {
    echo -e "${CYAN}📊 STATUS DO SISTEMA:${NC}"
    echo ""
    
    local cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local mem=$(free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}')
    local disco=$(df -h / | awk 'NR==2 {print $5}')
    
    echo "💻 CPU: ${cpu}%"
    echo "🧠 RAM: ${mem}%"
    echo "💾 Disco: ${disco}"
    echo ""
    
    echo "🟢 SERVIÇOS:"
    systemctl is-active ssh dropbear stunnel4 v2ray xray 2>/dev/null | while read svc; do
        if [[ "$svc" == "active" ]]; then
            echo "  ✅ $svc"        else
            echo "  🔴 $svc"
        fi
    done
}

# Menu principal do bot
menu_bot() {
    echo -e "${CYAN}"
    cat << "EOF"
 ╔═══════════════════════════════════════════╗
 ║    FUSION SSH - Bot Telegram v1.0        ║
 ║    Automação via Telegram                ║
 ╚═══════════════════════════════════════════╝
EOF
echo -e "${NC}"

    echo -e "${YELLOW}📋 COMANDOS DISPONÍVEIS:${NC}"
    echo ""
    echo "/start - Iniciar o bot"
    echo "/ajuda - Mostrar ajuda"
    echo "/status - Ver status do sistema"
    echo "/criar - Criar novo usuário SSH"
    echo "/renovar - Renovar usuário existente"
    echo "/listar - Listar usuários ativos"
    echo "/remover - Remover usuário"
    echo "/info - Informações do servidor"
    echo ""
}

# Processar comandos do Telegram
processar_comandos() {
    local offset=0
    
    echo -e "${GREEN}🤖 Bot Telegram iniciado!${NC}"
    echo "Aguardando comandos..."
    echo ""
    
    while true; do
        # Buscar atualizações
        local updates=$(curl -s "${API_URL}/getUpdates?offset=${offset}&timeout=30")
        
        # Extrair informações
        local chat_id=$(echo "${updates}" | jq -r '.result[-1].message.chat.id')
        local texto=$(echo "${updates}" | jq -r '.result[-1].message.text')
        local msg_id=$(echo "${updates}" | jq -r '.result[-1].message.message_id')
        
        if [[ "${chat_id}" != "null" && "${chat_id}" != "${offset}" ]]; then
            offset=$((msg_id + 1))
                        # Verificar se é admin
            if [[ "${chat_id}" != "${ADMIN_ID}" ]]; then
                enviar_mensagem "${chat_id}" "❌ Acesso negado! Apenas administradores."
                continue
            fi
            
            # Processar comandos
            case "${texto}" in
                "/start")
                    enviar_mensagem "${chat_id}" "👋 *Bem-vindo ao Fusion SSH Bot!*\n\nUse /ajuda para ver os comandos disponíveis."
                    ;;
                "/ajuda")
                    menu_bot
                    enviar_mensagem "${chat_id}" "$(menu_bot)"
                    ;;
                "/status")
                    local status=$(status_sistema)
                    enviar_mensagem "${chat_id}" "${status}"
                    ;;
                "/listar")
                    local lista=$(listar_usuarios)
                    enviar_mensagem "${chat_id}" "${lista}"
                    ;;
                "/info")
                    local info=$(uname -a)
                    local uptime=$(uptime -p)
                    enviar_mensagem "${chat_id}" "🖥️ *Informações do Servidor:*\n\n\`\`\`${info}\`\`\`\n\n⏱️ *Uptime:* ${uptime}"
                    ;;
                "/criar")
                    enviar_mensagem "${chat_id}" "📝 *Criar Usuário SSH*\n\nEnvie no formato:\n\`/criar usuario senha dias\`\n\nExemplo:\n\`/criar joao 123456 30\`"
                    ;;
                "/renovar")
                    enviar_mensagem "${chat_id}" "📝 *Renovar Usuário*\n\nEnvie no formato:\n\`/renovar usuario dias\`\n\nExemplo:\n\`/renovar joao 30\`"
                    ;;
                "/remover")
                    enviar_mensagem "${chat_id}" "📝 *Remover Usuário*\n\nEnvie no formato:\n\`/remover usuario\`\n\nExemplo:\n\`/remover joao\`"
                    ;;
                /criar\ *)
                    # Extrair parâmetros
                    local params=$(echo "${texto}" | cut -d' ' -f2-)
                    local usuario=$(echo "${params}" | awk '{print $1}')
                    local senha=$(echo "${params}" | awk '{print $2}')
                    local dias=$(echo "${params}" | awk '{print $3}')
                    
                    if [[ -n "${usuario}" && -n "${senha}" && -n "${dias}" ]]; then
                        local resultado=$(criar_usuario "${usuario}" "${senha}" "${dias}")
                        enviar_mensagem "${chat_id}" "${resultado}"
                    else
                        enviar_mensagem "${chat_id}" "❌ *Erro!* Use: \`/criar usuario senha dias\`"
                    fi                    ;;
                /renovar\ *)
                    local params=$(echo "${texto}" | cut -d' ' -f2-)
                    local usuario=$(echo "${params}" | awk '{print $1}')
                    local dias=$(echo "${params}" | awk '{print $2}')
                    
                    if [[ -n "${usuario}" && -n "${dias}" ]]; then
                        local resultado=$(renovar_usuario "${usuario}" "${dias}")
                        enviar_mensagem "${chat_id}" "${resultado}"
                    else
                        enviar_mensagem "${chat_id}" "❌ *Erro!* Use: \`/renovar usuario dias\`"
                    fi
                    ;;
                /remover\ *)
                    local usuario=$(echo "${texto}" | cut -d' ' -f2)
                    
                    if [[ -n "${usuario}" ]]; then
                        local resultado=$(remover_usuario "${usuario}")
                        enviar_mensagem "${chat_id}" "${resultado}"
                    else
                        enviar_mensagem "${chat_id}" "❌ *Erro!* Use: \`/remover usuario\`"
                    fi
                    ;;
                *)
                    enviar_mensagem "${chat_id}" "❓ *Comando não reconhecido!*\n\nUse /ajuda para ver os comandos disponíveis."
                    ;;
            esac
        fi
        
        sleep 2
    done
}

# Inicialização
clear
menu_bot

echo -e "${YELLOW}⚠️  ATENÇÃO:${NC}"
echo "Antes de usar, edite este arquivo e configure:"
echo "  1. BOT_TOKEN - Token do seu bot"
echo "  2. ADMIN_ID - Seu Chat ID do Telegram"
echo ""
echo -e "${GREEN}Para obter o token:"
echo "  1. Abra o Telegram"
echo "  2. Busque por @BotFather"
echo "  3. Envie /newbot"
echo "  4. Siga as instruções"
echo ""
echo -e "${GREEN}Para obter seu Chat ID:"
echo "  1. Busque por @userinfobot"echo "  2. Envie /start"
echo "  3. Copie seu ID"
echo ""

read -p "Pressione Enter para iniciar o bot..."

# Iniciar bot
processar_comandos
