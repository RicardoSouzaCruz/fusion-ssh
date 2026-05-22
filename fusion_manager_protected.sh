# =====================================================
# © 2026 RicardoSouzaCruz - Fuzion SSH Manager Pro
# É PROIBIDA A REVENDA/REDISTRIBUIÇÃO NÃO AUTORIZADA
# Licença: Uso pessoal apenas - Todos direitos reservados
# =====================================================
#!/bin/bash
# ==========================================================================
#  FUZION SSH MANAGE PRO - EDIÇÃO PREMIUM HORIZON
#  GERADO EM: 2026-05-22 - 100% PERSONALIZADO
# ==========================================================================
#  SO COMPATÍVEL: UBUNTU 20.04 - 24.04 LTS | DEBIAN 11 - 12
# ==========================================================================

# Cores de Output
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_PURPLE='\033[0;35m'
C_CYAN='\033[0;36m'
C_WHITE='\033[0;37m'
C_NC='\033[0m' # No Color
C_UNDERLINE='\033[4m'

# Variáveis Configuradas pelo Construtor Fusion
SSH_PORT=2222
XRAY_PORT=443
DROPBEAR_PORT=443
SQUID_PORT=8888
BADVPN_PORT=7300
SLOWDNS_PORT=53
TG_ENABLED=false
TG_TOKEN=""
TG_CHAT_ID=""
FLAG_AUTO_PURGE=true
FLAG_BBR=true
FLAG_ANTI_TORRENT=false
BANNER_TEXT="FUZION SSH MANAGE PRO"

# Arquivo de banco de dados local para guardar vencimentos adicionais no VPS
FUSION_DB="/etc/fusion_users.db"
touch "$FUSION_DB"

# Seta permissões seguras
chmod 600 "$FUSION_DB"

# Requisito base
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${C_RED}✖ ERRO: Este script deve ser executado como root!${C_NC}"
    exit 1
fi

# Função de LOG integrada com Telegram
notify_telegram() {
    local message="$1"
    if [[ "$TG_ENABLED" == "true" ]] && [[ "$TG_TOKEN" != "TELEGRAM_BOT_TOKEN_AQUI" ]]; then
        curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
            -d "chat_id=$TG_CHAT_ID" \
            -d "text=🔔 [FUZION ALERT]: $message" \
            -d "parse_mode=Markdown" >/dev/null 2>&1
    fi
}

# Cabeçalho estético (Estilo Horizon Box com Estatísticas Live)
show_banner() {
    clear
    local load_v="0.0"
    if [[ -f /proc/loadavg ]]; then
        load_v=$(cat /proc/loadavg | awk '{print $1}')
    fi
    local ram_u="0"
    local ram_t="0"
    if free -m &>/dev/null; then
        ram_u=$(free -m | awk '/Mem:/ {print $3}')
        ram_t=$(free -m | awk '/Mem:/ {print $2}')
    fi
    local disc_u="0%"
    if df -h / &>/dev/null; then
        disc_u=$(df -h / | tail -1 | awk '{print $5}')
    fi
    local active_conn="0"
    if ss -t &>/dev/null; then
        active_conn=$(ss -t | grep -c ESTAB)
    fi
    local vps_ip="VPS_IP"
    vps_ip=$(curl -s ifconfig.me || wget -qO- ifconfig.me || echo "VPS_IP")

    echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  ${C_PURPLE}███████╗██╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗${C_NC}  ${C_CYAN}🛡️  PREMIUM APP${C_NC}  ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  ${C_PURPLE}██╔════╝██║   ██║╚══███╔╝██║██╔═══██╗████╗  ██║${C_NC}  ${C_CYAN}   V2.5.4     ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  ${C_PURPLE}█████╗  ██║   ██║  ███╔╝ ██║██║   ██║██╔██╗ ██║${C_NC}  ${C_CYAN}   EDITION    ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  ${C_PURPLE}██╔══╝  ██║   ██║ ███╔╝  ██║██║   ██║██║╚██╗██║  ${C_CYAN}   ONLINE     ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  ${C_PURPLE}██║     ╚██████╔╝███████╗██║╚██████╔╝██║ ╚████║${C_NC}  ${C_CYAN}              ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  ${C_PURPLE}╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝${C_NC}  ${C_CYAN}              ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}├──────────────────────────────────────────────────────────────────────────┤${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  👑 ${C_WHITE}NOME DO SISTEMA:${C_NC} ${C_YELLOW}FUZION SSH MANAGE PRO${C_NC}                            ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}├──────────────────────────────────────────────────────────────────────────┤${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  🔰 ${C_WHITE}Endereço IP:${C_NC} ${C_GREEN}$vps_ip${C_NC}       | ${C_WHITE}Tema Banner:${C_NC} ${C_YELLOW}$BANNER_TEXT${C_NC}       ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  📈 ${C_WHITE}Carga CPU:${C_NC} ${C_GREEN}$load_v${C_NC}   | ${C_WHITE}RAM:${C_NC} ${C_GREEN}${ram_u}MB/${ram_t}MB${C_NC}   | ${C_WHITE}Armazenamento:${C_NC} ${C_GREEN}$disc_u${C_NC}   ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}│${C_NC}  🔌 ${C_WHITE}Conexões Ativas VPS:${C_NC} ${C_BLUE}$active_conn${C_NC}                                       ${C_CYAN}│${C_NC}"
    echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
}

# Menu Principal Com Categorias (Abas / Pastas Estilo Horizon)
main_menu() {
    while true; do
        show_banner
        echo -e " ${C_PURPLE}📁 PAINEL PRINCIPAL DE CONTROLES FUZION${C_NC}"
        echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[1]${C_NC} 📂 ${C_WHITE}Pasta - Gerenciar Contas Clientes${C_NC}                           ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[2]${C_NC} 📂 ${C_WHITE}Pasta - Protocolos & Conexões (VLESS/Squid/Dropbear)${C_NC}      ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[3]${C_NC} 📂 ${C_WHITE}Pasta - Controles de Segurança & Performance (BBR/Torrent)${C_NC} ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[4]${C_NC} 📂 ${C_WHITE}Pasta - Ferramentas de Manutenção & Alertas do Sistema${C_NC}    ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[5]${C_NC} 📁 ${C_WHITE}Pasta - Gerenciamento de Backups Globais (Salvar/Restaurar)${C_NC}  ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[6]${C_NC} ⚙️  ${C_WHITE}Pasta - Ajustar Portas e Interfaces de Serviços             ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}                                                                          │"
        echo -e "${C_CYAN}│${C_NC}  ${C_RED}[0]${C_NC} ❌ ${C_RED}Fechar Console Administrativo${C_NC}                            ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
        read -p "Selecione uma pasta [0-6]: " option

        case $option in
            1) menu_contas ;;
            2) menu_protocolos ;;
            3) menu_seguranca ;;
            4) menu_sistema ;;
            5) menu_backup ;;
            6) change_service_ports ;;
            0) echo -e "\n${C_GREEN}👋 Obrigado por usar o Fuzion SSH Manage Pro! Saindo...\n${C_NC}"; exit 0 ;;
            *) echo -e "${C_RED}Opção Inválida! Digite novamente.${C_NC}"; sleep 1.5 ;;
        esac
    done
}

# Pasta 1: Gerenciador de Contas
menu_contas() {
    while true; do
        show_banner
        echo -e " ${C_YELLOW}📂 DIRETÓRIO: MENU PRINCIPAL > GERENCIAR CONTAS CLIENTES${C_NC}"
        echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[1]${C_NC} 👤 Criar Novo Usuário SSH/VPN (Acesso Seguro)               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[2]${C_NC} ❌ Remover Usuário do Sistema                               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[3]${C_NC} ⚡ Renovar Período de Validade (Dias de Acesso)            ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[4]${C_NC} 🔑 Alterar Senha de Acesso do Cliente                        ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[5]${C_NC} 📋 Listar Todos os Usuários & Vencimentos                     ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[6]${C_NC} 🔒 Bloquear ou Desbloquear Conta de Cliente                 ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[7]${C_NC} 👥 Visualizar Clientes Online / Desconectar Usuários        ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[8]${C_NC} 🛡️  Alterar Limite de Conexões do Cliente                     ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}                                                                          │"
        echo -e "${C_CYAN}│${C_NC}  ${C_RED}[0]${C_NC} ↩️ Voltar ao Painel Principal                               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
        read -p "Selecione uma opção [0-8]: " opt_contas
        case $opt_contas in
            1) create_ssh_user ;;
            2) delete_ssh_user ;;
            3) renew_ssh_user ;;
            4) change_user_password ;;
            5) list_users ;;
            6) toggle_user_status ;;
            7) list_online_users ;;
            8) change_user_connection_limit ;;
            0) break ;;
            *) echo -e "${C_RED}Opção Inválida!${C_NC}"; sleep 1 ;;
        esac
    done
}

# Criar Usuário SSH
create_ssh_user() {
    show_banner
    echo -e "${C_CYAN}👤 CRIAR NOVO USUÁRIO SSH/VPN${C_NC}"
    echo -e "----------------------------------------------------------------------"
    read -p "Digite o Username: " username
    
    # validação de usuário
    if [[ ! "$username" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo -e "${C_RED}✖ Username inválido! Use apenas letras e números.${C_NC}"
        read -p "Pressione Enter para voltar..." ; return
    fi
    
    if id "$username" &>/dev/null; then
        echo -e "${C_RED}✖ ERRO: Este usuário já existe no VPS!${C_NC}"
        read -p "Pressione Enter para voltar..." ; return
    fi

    # Senha do cliente
    read -p "Definir senha manualmente? (s/n): " confirm_pass
    if [[ "$confirm_pass" == "S" || "$confirm_pass" == "s" ]]; then
        read -s -p "Digite a senha do Usuário: " password
        echo ""
    else
        # Geração dinâmica altamente segura
        password=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 8 | head -n 1)
        echo -e "🔑 Senha gerada automaticamente: ${C_GREEN}$password${C_NC}"
    fi

    read -p "Número de dias de validade (Ex: 30): " valid_days
    if [[ ! "$valid_days" =~ ^[0-9]+$ ]]; then
        valid_days=30
    fi

    read -p "Limite de conexões simultâneas (Multi-login) [Ex: 1]: " limit_conn
    if [[ ! "$limit_conn" =~ ^[0-9]+$ ]]; then
        limit_conn=1
    fi

    # Datas de expiração Unix standard e banco extra
    expiration_date=$(date -d "+$valid_days days" +%Y-%m-%d)
    
    # Adiciona usuário no linux
    useradd -M -s /bin/false -e "$expiration_date" "$username"
    echo "$username:$password" | chpasswd

    # Guarda metadados no nosso banco de dados
    echo "$username|$expiration_date|$password|$limit_conn" >> "$FUSION_DB"
    
    # Notifica via terminal
    echo -e "\\n${C_GREEN}✓ Usuário '$username' cadastrado com sucesso!${C_NC}"
    echo -e "💻 Usuário: ${C_WHITE}$username${C_NC}"
    echo -e "🔑 Senha: ${C_WHITE}$password${C_NC}"
    echo -e "📅 Expiração: ${C_YELLOW}$expiration_date (Em $valid_days dias)${C_NC}"
    echo -e "👥 Limite Conexões: ${C_CYAN}$limit_conn simultânea(s)${C_NC}"
    
    # Notificação Inteligente via Telegram
    notify_telegram "👤 *Novo Usuário SSH Criado!*\\nServer: \$(curl -s ifconfig.me)\\nUser: \`$username\`\\nPass: \`$password\`\\nValidade: \`$expiration_date\`\\nLimite: \`$limit_conn\`"

    read -p "Pressione Enter para prosseguir..."
}

# Deletar conta
delete_ssh_user() {
    show_banner
    echo -e "${C_RED}✖ REMOVER USUÁRIO DO SISTEMA${C_NC}"
    echo -e "----------------------------------------------------------------------"
    read -p "Digite o Username a deletar: " username
    
    if ! id "$username" &>/dev/null; then
        echo -e "${C_RED}✖ ERRO: Usuário '$username' não existe!${C_NC}"
        read -p "Pressione Enter para voltar..." ; return
    fi

    userdel -f "$username"
    # Remove do DB de vencimentos
    sed -i "/^$username|/d" "$FUSION_DB"
    
    echo -e "${C_GREEN}✓ Conta de '$username' excluida e banida completamente do VPS!${C_NC}"
    notify_telegram "🗑️ *Usuário SSH Removido!*\\nUser: \`$username\`\\nStatus: Excluido do VPS."
    
    read -p "Pressione [Enter] para retornar..."
}

# Renovar validades
renew_ssh_user() {
    show_banner
    echo -e "${C_CYAN}⚡ RENOVAR PERÍODO DE VALIDADE${C_NC}"
    echo -e "----------------------------------------------------------------------"
    read -p "Username a renovar: " username
    
    if ! id "$username" &>/dev/null; then
        echo -e "${C_RED}✖ ERRO: Usuário '$username' não existe no Linux!${C_NC}"
        read -p "Pressione Enter para voltar..." ; return
    fi

    read -p "Quantos dias extras adicionar? (Ex: 30): " add_days
    if [[ ! "$add_days" =~ ^[0-9]+$ ]]; then
        add_days=30
    fi

    new_expiry=$(date -d "+$add_days days" +%Y-%m-%d)
    chage -E "$new_expiry" "$username"

    # Atualiza em nosso arquivo db local também
    existing_pwd=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f3)
    existing_limit=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f4)
    [[ -z "$existing_limit" ]] && existing_limit=1
    sed -i "/^$username|/d" "$FUSION_DB"
    echo "$username|$new_expiry|$existing_pwd|$existing_limit" >> "$FUSION_DB"

    echo -e "${C_GREEN}✓ Validade de '$username' estendida com êxito!${C_NC}"
    echo -e "📅 Nova Expiração: ${C_YELLOW}$new_expiry${C_NC}"

    notify_telegram "⚡ *Usuário SSH Renovado!*\\nUser: \`$username\`\\nNova Expiração: \`$new_expiry\`"
    read -p "Pressione [Enter] para retornar..."
}

# Alterar senha de cliente
change_user_password() {
    show_banner
    echo -e "${C_CYAN}🔑 ALTERAR SENHA DO CLIENTE${C_NC}"
    echo -e "----------------------------------------------------------------------"
    read -p "Username: " username
    if ! id "$username" &>/dev/null; then
        echo -e "${C_RED}✖ ERRO: Usuário '$username' não existe!${C_NC}"
        read -p "Entrar para continuar..."; return
    fi

    read -s -p "Digite a NOVA senha de acesso: " new_password
    echo ""
    echo "$username:$new_password" | chpasswd

    # Atualiza DB
    existing_expiry=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f2)
    existing_limit=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f4)
    [[ -z "$existing_limit" ]] && existing_limit=1
    sed -i "/^$username|/d" "$FUSION_DB"
    echo "$username|$existing_expiry|$new_password|$existing_limit" >> "$FUSION_DB"

    echo -e "${C_GREEN}✓ Credenciais de acesso de '$username' alteradas!${C_NC}"
    notify_telegram "🔑 *Senha Alterada!*\\nUser: \`$username\`\\nAcesso atualizado com nova credencial SSH."
    read -p "Entrar para continuar..."
}

# Listar Clientes
list_users() {
    show_banner
    echo -e "${C_CYAN}📋 CLIENTES CADASTRADOS & STATUS DE LIMITE${C_NC}"
    echo -e "----------------------------------------------------------------------------"
    printf "%-15s | %-12s | %-12s | %-8s | %-8s\n" "USUÁRIO" "EXPIRAÇÕES" "DIAS REST." "LIMITES" "STATUS"
    echo -e "----------------------------------------------------------------------------"
    
    local total=0
    local ativos=0
    local expirados=0

    # Iterar sobre usuários reais cadastrados no linux com UID >= 1000
    while IFS=: read -r user _ uid _ _ _ _; do
        if [[ $uid -ge 1000 && "$user" != "nobody" ]]; then
            # Obter expiração
            expire_unix=$(chage -l "$user" | grep "Account expires" | cut -d: -f2 | xargs)
            if [[ "$expire_unix" == "never" || -z "$expire_unix" ]]; then
                exp_date="Sem Limite"
                days_left="N/A"
                status_v="${C_GREEN}ATIVO${C_NC}"
                ((ativos++))
            else
                formatted_exp=$(date -d "$expire_unix" +%Y-%m-%d 2>/dev/null)
                # Cálculo de dias restantes
                date_unix=$(date -d "$formatted_exp" +%s 2>/dev/null)
                today_unix=$(date -d "$(date +%Y-%m-%d)" +%s)
                diff_sec=$((date_unix - today_unix))
                days_left=$((diff_sec / 86400))
                
                if [[ $days_left -le 0 ]]; then
                    status_v="${C_RED}EXPIRADO${C_NC}"
                    days_left="0"
                    ((expirados++))
                else
                    status_v="${C_GREEN}ATIVO${C_NC}"
                    ((ativos++))
                fi
                exp_date=$formatted_exp
            fi
            
            # Limite e conexões logadas
            local limit_v=$(grep "^$user|" "$FUSION_DB" | cut -d'|' -f4)
            [[ -z "$limit_v" ]] && limit_v=1
            local real_conns=$(ps -ef | grep -E "sshd|dropbear" | grep -v grep | grep -w "$user" | wc -l)
            
            ((total++))
            printf "%-15s | %-12s | %-12s | %-8s | %b\n" "$user" "$exp_date" "$days_left dias" "$real_conns/$limit_v" "$status_v"
        fi
    done < /etc/passwd

    echo -e "----------------------------------------------------------------------------"
    echo -e "📊 Ativos: ${C_GREEN}$ativos${C_NC}  | Expirados: ${C_RED}$expirados${C_NC} | Total: ${C_WHITE}$total${C_NC}"
    read -p "Pressione Enter para prosseguir..."
}

# Bloquear / Desbloquear Usuário
toggle_user_status() {
    show_banner
    echo -e "${C_CYAN}🔒 BLOQUEAR / DESBLOQUEAR CONTA DE CLIENTE${C_NC}"
    echo -e "----------------------------------------------------------------------"
    read -p "Digite o Username: " username
    if ! id "$username" &>/dev/null; then
        echo -e "${C_RED}✖ ERRO: Usuário '$username' não existe!${C_NC}"
        read -p "Entrar para continuar..."; return
    fi

    # Se estiver bloqueado "L"
    if passwd -S "$username" | grep -q "L"; then
        usermod -U "$username" 2>/dev/null
        chsh -s /bin/false "$username" 2>/dev/null
        echo -e "${C_GREEN}✓ Usuário '$username' DESBLOQUEADO com sucesso!${C_NC}"
        notify_telegram "🔓 *Usuário SSH Desbloqueado!*\\nUser: \`$username\`"
    else
        usermod -L "$username" 2>/dev/null
        chsh -s /usr/sbin/nologin "$username" 2>/dev/null
        echo -e "${C_RED}✓ Usuário '$username' BLOQUEADO com sucesso!${C_NC}"
        notify_telegram "🔒 *Usuário SSH Bloqueado!*\\nUser: \`$username\`"
    fi
    read -p "Pressione Enter para prosseguir..."
}

# Visualizar Clientes Online e Desconectar
list_online_users() {
    show_banner
    echo -e "${C_CYAN}👥 CLIENTES OPERANDO ONLINE NO TÚNEL AGORA${C_NC}"
    echo "----------------------------------------------------------------------"
    printf "%-18s | %-12s | %-15s\n" "USUÁRIO" "PID PROCESSO" "TEMPO OPERANTE"
    echo "----------------------------------------------------------------------"
    
    local has_conns=0
    # Procurar conexões estabelecidas por sshd e dropbear de usuários normais
    while read -r line; do
        if [[ -n "$line" ]]; then
            local user=$(echo "$line" | awk '{print $1}')
            local pid=$(echo "$line" | awk '{print $2}')
            local time_op=$(echo "$line" | awk '{print $5}')
            local user_uid=$(id -u "$user" 2>/dev/null)
            if [[ -n "$user_uid" ]] && [[ $user_uid -ge 1000 ]]; then
                printf "%-18s | %-12s | %-15s\n" "$user" "$pid" "$time_op"
                has_conns=1
            fi
        fi
    done < <(ps -ef | grep -E "sshd|dropbear" | grep -v grep | grep -v root)
    
    if [[ $has_conns -eq 0 ]]; then
        echo -e "                 ${C_YELLOW}Nenhuma conexão ativa detectada neste momento.${C_NC}"
    fi
    echo "----------------------------------------------------------------------"
    echo -e " [1] Derrubar/Desconectar Usuário Específico"
    echo -e " [0] Voltar"
    read -p "Opção: " opt_online
    if [[ "$opt_online" == "1" ]]; then
        read -p "Digite o Username do cliente que deseja derrubar: " kill_user
        if [[ -n "$kill_user" ]]; then
            pkill -u "$kill_user" -f "sshd|dropbear" 2>/dev/null
            echo -e "${C_GREEN}✓ Todas as sessões SSH de '$kill_user' foram terminadas!${C_NC}"
        fi
        sleep 1.5
    fi
}

# Alterar limite de conexões do cliente
change_user_connection_limit() {
    show_banner
    echo -e "${C_CYAN}🛡️ ALTERAR LIMITE DE CONEXÕES SIMULTÂNEAS${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Username: " username
    if ! id "$username" &>/dev/null; then
         echo -e "${C_RED}✖ ERRO: Usuário '$username' não existe!${C_NC}"
         read -p "Entrar para continuar..."; return
    fi
    
    local current_limit=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f4)
    [[ -z "$current_limit" ]] && current_limit=1
    
    echo -e "Limite Atual: ${C_YELLOW}$current_limit${C_NC}"
    read -p "Novo limite de conexões simultâneas (Ex: 2): " new_limit
    if [[ ! "$new_limit" =~ ^[0-9]+$ ]]; then
         new_limit=1
    fi
    
    local existing_pwd=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f3)
    local existing_exp=$(grep "^$username|" "$FUSION_DB" | cut -d'|' -f2)
    
    sed -i "/^$username|/d" "$FUSION_DB"
    echo "$username|$existing_exp|$existing_pwd|$new_limit" >> "$FUSION_DB"
    
    echo -e "${C_GREEN}✓ Limite de conexões de '$username' alterado para $new_limit!${C_NC}"
    notify_telegram "🛡️ *Limite Alterado!*\\nUser: \`$username\`\\nNovo Limite: \`$new_limit\`"
    read -p "Entrar para continuar..."
}

# Menu de Backups
menu_backup() {
    while true; do
        show_banner
        echo -e " ${C_PURPLE}📂 DIRETÓRIO: MENU PRINCIPAL > GERENCIADOR DE BACKUPS${C_NC}"
        echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[1]${C_NC} 📥 Exportar Clientes (Gerar Código Base64 de Segurança)     ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[2]${C_NC} 📤 Restaurar Clientes (Inserir Código Base64 de Backup)    ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}                                                                          │"
        echo -e "${C_CYAN}│${C_NC}  ${C_RED}[0]${C_NC} ↩️ Voltar ao Painel Principal                               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
        read -p "Selecione uma opção [0-2]: " opt_backup
        case $opt_backup in
            1) backup_users ;;
            2) restore_users ;;
            0) break ;;
            *) echo -e "${C_RED}Opção Inválida!${C_NC}"; sleep 1 ;;
        esac
    done
}

# Realizar backup
backup_users() {
    show_banner
    echo -e "${C_CYAN}📥 GERENCIADOR DE BACKUPS - EXPORTAR CLIENTES${C_NC}"
    echo "----------------------------------------------------------------------"
    if [[ ! -s "$FUSION_DB" ]]; then
        echo -e "${C_RED}❌ Seu banco de dados $FUSION_DB está vazio ou não existe! ${C_NC}"
        read -p "Pressione Enter para voltar..."; return
    fi
    
    echo -e "${C_YELLOW}Compactando e gerando código de Backup Base64 de segurança...${C_NC}"
    local b64_backup=$(cat "$FUSION_DB" | base64 -w 0)
    
    echo -e "----------------------------------------------------------------------"
    echo -e "${C_WHITE}CÓDIGO DE BACKUP GERADO (Copie a linha inteira abaixo):${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "${C_GREEN}$b64_backup${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "Guarde esse código seguro. Com ele você restaura em qualquer VPS nova!"
    read -p "Pressione Enter para prosseguir..."
}

# Restaurar backup
restore_users() {
    show_banner
    echo -e "${C_CYAN}📤 GERENCIADOR DE BACKUPS - RESTAURAR CLIENTES${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Cole o código Base64 do seu backup aqui: " b64_input
    if [[ -z "$b64_input" ]]; then
         echo -e "${C_RED}✖ Entrada vazia!${C_NC}"
         read -p "Voltar..."; return
    fi
    
    local decoded_content=$(echo "$b64_input" | base64 -d 2>/dev/null)
    if [[ -z "$decoded_content" ]]; then
         echo -e "${C_RED}✖ Código de backup inválido (Erro de decodificação Base64)!${C_NC}"
         read -p "Voltar..."; return
    fi
    
    echo -e "${C_YELLOW}Restaurando usuários decodificados no Linux VPS...${C_NC}"
    while IFS='|' read -r user exp pwd limit || [[ -n "$user" ]]; do
         [[ -z "$user" ]] && continue
         if id "$user" &>/dev/null; then
             echo -e "${C_YELLOW}⚠️ Usuário '$user' já existe. Ignorando recriação Linux.${C_NC}"
         else
             useradd -M -s /bin/false -e "$exp" "$user" 2>/dev/null
             echo "$user:$pwd" | chpasswd 2>/dev/null
             echo -e "${C_GREEN}✓ Usuário '$user' restaurado e ativo para data $exp.${C_NC}"
         fi
    done <<< "$decoded_content"
    
    # Salva no DB local, juntando sem duplicar
    echo "$decoded_content" >> "$FUSION_DB"
    # Remove duplicados
    sort -u "$FUSION_DB" -o "$FUSION_DB"
    
    echo -e "${C_GREEN}✓ Restauração concluída com sucesso absoluto!${C_NC}"
    read -p "Pressione Enter para prosseguir..."
}

# Gerenciador de portas
change_service_ports() {
    show_banner
    echo -e "${C_CYAN}⚙️ GERENCIADOR DE INTERFACES E PORTAS DE REDE${C_NC}"
    echo "----------------------------------------------------------------------"
    echo -e " Porta SSH Principal:     ${C_GREEN}$SSH_PORT${C_NC}"
    echo -e " Porta XRay VLESS:        ${C_GREEN}$XRAY_PORT${C_NC}"
    echo -e " Porta Dropbear:          ${C_GREEN}$DROPBEAR_PORT${C_NC}"
    echo -e " Porta Squid Proxy:       ${C_GREEN}$SQUID_PORT${C_NC}"
    echo -e " Porta BadVPN Acelerador:  ${C_GREEN}$BADVPN_PORT${C_NC}"
    echo -e " Porta SlowDNS:           ${C_GREEN}$SLOWDNS_PORT${C_NC}"
    echo "----------------------------------------------------------------------"
    echo -e "  [1] Alterar Porta SSH Principal"
    echo -e "  [2] Alterar Porta Xray VLESS"
    echo -e "  [3] Alterar Porta Dropbear SSH"
    echo -e "  [4] Alterar Porta Squid Proxy"
    echo -e "  [5] Alterar Porta BadVPN Acelerador"
    echo -e "  [6] Alterar Porta SlowDNS"
    echo -e "  [0] Voltar"
    read -p "Escolha o serviço [0-6]: " opt_ch_port
    case $opt_ch_port in
        1)
            read -p "Nova porta SSH: " new_ssh
            if [[ "$new_ssh" =~ ^[0-9]+$ ]]; then
                # Altera no sshd_config
                sed -i "s/^Port .*/Port $new_ssh/g" /etc/ssh/sshd_config 2>/dev/null
                systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
                SSH_PORT=$new_ssh
                echo -e "${C_GREEN}✓ Porta OpenSSH alterada para $new_ssh e reiniciada!${C_NC}"
            fi
            ;;
        2)
            read -p "Nova porta Xray VLESS Reality: " new_xr
            if [[ "$new_xr" =~ ^[0-9]+$ ]] && [[ -f /usr/local/etc/xray/config.json ]]; then
                sed -i "s/\"port\": [0-9]*/\"port\": $new_xr/g" /usr/local/etc/xray/config.json 2>/dev/null
                systemctl restart xray 2>/dev/null
                XRAY_PORT=$new_xr
                echo -e "${C_GREEN}✓ Porta XRay VLESS Reality alterada para $new_xr!${C_NC}"
            fi
            ;;
        3)
            read -p "Nova porta Dropbear: " new_db
            if [[ "$new_db" =~ ^[0-9]+$ ]]; then
                sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$new_db/g" /etc/default/dropbear 2>/dev/null
                systemctl restart dropbear 2>/dev/null
                DROPBEAR_PORT=$new_db
                echo -e "${C_GREEN}✓ Porta Dropbear alterada para $new_db!${C_NC}"
            fi
            ;;
        4)
            read -p "Nova porta Squid: " new_sq
            if [[ "$new_sq" =~ ^[0-9]+$ ]]; then
                sed -i "s/http_port [0-9]*/http_port $new_sq/g" /etc/squid/squid.conf 2>/dev/null
                systemctl restart squid 2>/dev/null
                SQUID_PORT=$new_sq
                echo -e "${C_GREEN}✓ Porta Squid Proxy alterada para $new_sq!${C_NC}"
            fi
            ;;
        5)
            read -p "Nova porta BadVPN: " new_bv
            if [[ "$new_bv" =~ ^[0-9]+$ ]]; then
                killall badvpn-udpgw 2>/dev/null
                nohup badvpn-udpgw --listen-addr 127.0.0.1:$new_bv --max-clients 500 >/dev/null 2>&1 &
                BADVPN_PORT=$new_bv
                echo -e "${C_GREEN}✓ Porta BadVPN alterada para $new_bv e acelerador ativo!${C_NC}"
            fi
            ;;
        6)
            read -p "Nova porta SlowDNS: " new_sd
            if [[ "$new_sd" =~ ^[0-9]+$ ]]; then
                iptables -t nat -F PREROUTING 2>/dev/null
                iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports $new_sd 2>/dev/null
                SLOWDNS_PORT=$new_sd
                echo -e "${C_GREEN}✓ SlowDNS redirecionado para a porta $new_sd!${C_NC}"
            fi
            ;;
    esac
    sleep 1.5
}

# Pasta 2: Gerenciador de Protocolos & Conexões
menu_protocolos() {
    while true; do
        show_banner
        echo -e " ${C_GREEN}📂 DIRETÓRIO: MENU PRINCIPAL > PROTOCOLOS & ACESSOS${C_NC}"
        echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[1]${C_NC} 🌐 Configurar XRay Reality VLESS (Porta: $XRAY_PORT)               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[2]${C_NC} 📦 Instalar Dropbear SSH (Porta: $DROPBEAR_PORT)                  ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[3]${C_NC} 🦑 Instalar Squid Proxy local (Porta: $SQUID_PORT)                 ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[4]${C_NC} 🎮 Ativar BadVPN UDP Acelerador (Porta: $BADVPN_PORT)             ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[5]${C_NC} 📡 Instalar SlowDNS Tunneling (Porta: $SLOWDNS_PORT)               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}                                                                          │"
        echo -e "${C_CYAN}│${C_NC}  ${C_RED}[0]${C_NC} ↩️ Voltar ao Painel Principal                               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
        read -p "Selecione uma opção [0-5]: " opt_prot
        case $opt_prot in
            1) setup_xray_reality ;;
            2) install_dropbear_only ;;
            3) install_squid_only ;;
            4) install_badvpn_only ;;
            5) setup_slowdns ;;
            0) break ;;
            *) echo -e "${C_RED}Opção Inválida!${C_NC}"; sleep 1 ;;
        esac
    done
}

# Configurações do Xray Core Reality VLESS
setup_xray_reality() {
    show_banner
    echo -e "${C_CYAN}🌐 CONFIGURAÇÃO DE PROTOCOLO VLESS REALITY (XRAY)${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "O Xray Reality encripta seu tráfego e simula o protocolo HTTPS de sites"
    echo -e "famosos como Google, Cloudflare ou Microsoft, passando por qualquer rede."
    echo ""
    read -p "Deseja compilar/instalar o Xray Core Reality agora na porta $XRAY_PORT? (s/n): " confirm_xr
    
    if [[ "$confirm_xr" == "s" || "$confirm_xr" == "S" ]]; then
        echo -e "${C_YELLOW}🛰️ Fazendo download de binários oficiales da Xray-core...${C_NC}"
        bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta >/dev/null 2>&1
        
        # Gerar chaves criptográficas para o Reality
        xray_keys=$(xray x25519)
        priv_key=$(echo "$xray_keys" | grep "Private key:" | cut -d' ' -f3)
        pub_key=$(echo "$xray_keys" | grep "Public key:" | cut -d' ' -f3)
        client_uuid=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid)

        # Montar JSON de configuração segura no daemon xray
        mkdir -p /usr/local/etc/xray
        cat <<EOF > /usr/local/etc/xray/config.json
{
  "log": { "loglevel": "warning" },
  "inbounds": [{
    "port": $XRAY_PORT,
    "protocol": "vless",
    "settings": {
      "clients": [{ "id": "$client_uuid", "flow": "xtls-rprx-vision" }],
      "decryption": "none"
    },
    "streamSettings": {
      "network": "tcp",
      "security": "reality",
      "realitySettings": {
        "show": false,
        "dest": "cloudflare.com:443",
        "serverNames": ["cloudflare.com", "www.cloudflare.com"],
        "privateKey": "$priv_key",
        "shortIds": ["e8c89c45", "eeae436d"]
      }
    }
  }],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

        # Reiniciar xray
        systemctl restart xray >/dev/null 2>&1
        systemctl enable xray >/dev/null 2>&1

        echo -e "${C_GREEN}✓ Xray Reality Instalado e Ativo com sucesso!${C_NC}"
        echo -e "--------------------------------------------------------"
        echo -e "🔑 Client UUID: ${C_CYAN}$client_uuid${C_NC}"
        echo -e "🔑 Public Key:  ${C_WHITE}$pub_key${C_NC}"
        echo -e "--------------------------------------------------------"
        echo -e "📡 Link VLESS para Clientes (Importar v2rayNG/NekoBox):"
        echo -e "${C_YELLOW}vless://$client_uuid@\$(curl -s ifconfig.me):$XRAY_PORT?encryption=none&security=reality&sni=cloudflare.com&fp=chrome&pbk=$pub_key&flow=xtls-rprx-vision#Fusion-Xray-Reality${C_NC}"
        
        notify_telegram "🌐 *Xray Reality Ativado no Servidor!*\\nUUID: \`$client_uuid\`\\nPorta: \`$XRAY_PORT\`"
    else
        echo -e "${C_RED}Instalação cancelada.${C_NC}"
    fi
    read -p "Pressione Enter para continuar..."
}

# Instalar Dropbear SSH
install_dropbear_only() {
    show_banner
    echo -e "${C_CYAN}📦 INSTALAÇÃO INDEPENDENTE DROPBEAR SSH${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Deseja instalar/reinicar o Dropbear na porta $DROPBEAR_PORT? (s/n): " confirm_db
    if [[ "$confirm_db" == "s" || "$confirm_db" == "S" ]]; then
        echo -e "${C_YELLOW}Instalando Dropbear no VPS (Acesso otimizado)...${C_NC}"
        apt-get update && apt-get install -y dropbear >/dev/null 2>&1
        # Configura porta dropbear
        sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear 2>/dev/null
        sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT='$DROPBEAR_PORT'/g' /etc/default/dropbear 2>/dev/null
        systemctl restart dropbear 2>/dev/null
        systemctl enable dropbear 2>/dev/null
        echo -e "${C_GREEN}✓ Dropbear online e respondendo na porta $DROPBEAR_PORT!${C_NC}"
        notify_telegram "📦 *Dropbear Instalado/Reiniciado!*\\nPorta: \`$DROPBEAR_PORT\`"
    fi
    read -p "Pressione Enter para continuar..."
}

# Instalar Squid Proxy
install_squid_only() {
    show_banner
    echo -e "${C_CYAN}🦑 INSTALAÇÃO INDEPENDENTE SQUID PROXY${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Deseja instalar Squid Proxy local na porta $SQUID_PORT? (s/n): " confirm_sq
    if [[ "$confirm_sq" == "s" || "$confirm_sq" == "S" ]]; then
        echo -e "${C_YELLOW}Instalando Squid Proxy...${C_NC}"
        apt-get update && apt-get install -y squid >/dev/null 2>&1
        # Configuração Squid genérica para aceitar porta SSH local
        local my_ip=$(curl -s ifconfig.me || echo "127.0.0.1")
        cat <<EOF > /etc/squid/squid.conf
http_port $SQUID_PORT
acl SSH dst $my_ip
http_access allow all
EOF
        systemctl restart squid 2>/dev/null
        systemctl enable squid 2>/dev/null
        echo -e "${C_GREEN}✓ Squid Proxy rodando com sucesso na porta $SQUID_PORT!${C_NC}"
        notify_telegram "🦑 *Squid Proxy Instalado!*\\nPorta: \`$SQUID_PORT\`"
    fi
    read -p "Pressione Enter para continuar..."
}

# Instalar BadVPN
install_badvpn_only() {
    show_banner
    echo -e "${C_CYAN}🎮 ACELERADOR BADVPN (UDP GAME FORWARDING)${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Deseja ativar BadVPN para jogos/voz na porta $BADVPN_PORT? (s/n): " confirm_bv
    if [[ "$confirm_bv" == "s" || "$confirm_bv" == "S" ]]; then
        echo -e "${C_YELLOW}Alocando binários para BadVPN (UDP Gateway)...${C_NC}"
        wget -O /usr/bin/badvpn-udpgw "https://github.com/ambrop72/badvpn/raw/master/udpgw/badvpn-udpgw" >/dev/null 2>&1
        chmod +x /usr/bin/badvpn-udpgw 2>/dev/null
        # Mata qualquer instância antes
        killall badvpn-udpgw 2>/dev/null
        # Roda em background daemon
        nohup badvpn-udpgw --listen-addr 127.0.0.1:$BADVPN_PORT --max-clients 500 >/dev/null 2>&1 &
        echo -e "${C_GREEN}✓ Servidor BadVPN ativo e liberando UDP na porta $BADVPN_PORT!${C_NC}"
        notify_telegram "🎮 *BadVPN Ativado!*\\nPorta: \`$BADVPN_PORT\`"
    fi
    read -p "Pressione Enter para prosseguir..."
}

# Configurar SlowDNS
setup_slowdns() {
    show_banner
    echo -e "${C_CYAN}📡 INSTALAÇÃO E ATIVAÇÃO DO PROTOCOLO SLOWDNS${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "O SlowDNS cria um canal de navegação direta usando requisições DNS (Porta $SLOWDNS_PORT)."
    echo -e "Funciona em microchips telefônicos sem saldo, ideal para contingências lentas."
    echo ""
    read -p "Deseja levantar o SlowDNS na porta $SLOWDNS_PORT? (s/n): " conf_sd
    if [[ "$conf_sd" == "s" || "$conf_sd" == "S" ]]; then
        echo -e "${C_YELLOW}Instalando utilitários de DNS (dnsutils)...${C_NC}"
        apt-get update && apt-get install -y dnsutils iptables >/dev/null 2>&1
        
        # Redirecionamento DNS no iptables
        iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports $SLOWDNS_PORT 2>/dev/null
        
        echo -e "${C_GREEN}✓ Protocolo SlowDNS ativo e escutando na porta $SLOWDNS_PORT!${C_NC}"
        notify_telegram "📡 *SlowDNS habilitado!*\\nPorta: \`$SLOWDNS_PORT\`"
    else
        echo -e "${C_RED}Procedimento cancelado.${C_NC}"
    fi
    read -p "Pressione Enter para prosseguir..."
}

# Pasta 3: Segurança & Performance
menu_seguranca() {
    while true; do
        show_banner
        echo -e " ${C_BLUE}📂 DIRETÓRIO: MENU PRINCIPAL > PERFORMANCE & SEGURANÇA${C_NC}"
        echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[1]${C_NC} 🚀 Ativar Algoritmo TCP BBR (Aceleração e Estabilidade)      ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[2]${C_NC} 🚫 Ativar Bloqueio de Trackers Torrent (Anti P2P)           ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[3]${C_NC} 🧹 Agendar Purge Diário Automático (Remover Contas Vencidas) ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[4]${C_NC} 🛡️  Instalar Monitor de Conexões (Background Limiter Daemon)  ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}                                                                          │"
        echo -e "${C_CYAN}│${C_NC}  ${C_RED}[0]${C_NC} ↩️ Voltar ao Painel Principal                               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
        read -p "Selecione uma opção [0-4]: " opt_seg
        case $opt_seg in
            1) optimize_throughput ;;
            2) enable_anti_torrent_only ;;
            3) toggle_autopurge_cron ;;
            4) install_limiter_service ;;
            0) break ;;
            *) echo -e "${C_RED}Opção Inválida!${C_NC}"; sleep 1 ;;
        esac
    done
}

# Instalação do limite daemon do systemd
install_limiter_service() {
    show_banner
    echo -e "${C_CYAN}🛡️ CONFIGURAÇÃO DO DAEMON LIMITADOR DE CONEXÕES${C_NC}"
    echo "----------------------------------------------------------------------"
    echo -e "O Limiter daemon roda no systemd monitorando os limites de multilogin."
    echo -e "Se o usuário exceder o limite de login SSH, ele derruba as sessões extras."
    echo ""
    read -p "Deseja instalar/ativar o Limiter Daemon em background? (s/n): " conf_limiter
    if [[ "$conf_limiter" == "s" || "$conf_limiter" == "S" ]]; then
        echo -e "${C_YELLOW}Criando executável em /usr/local/bin/fusion-limiter.sh...${C_NC}"
        cat <<'EOF' > /usr/local/bin/fusion-limiter.sh
#!/bin/bash
FUSION_DB="/etc/fusion_users.db"
while true; do
    if [[ -f "$FUSION_DB" ]]; then
        while IFS='|' read -r user exp pwd limit || [[ -n "$user" ]]; do
            [[ -z "$user" ]] && continue
            [[ "$user" == "root" ]] && continue
            
            # Se o limite for nulo ou inválido, assume 1
            if [[ ! "$limit" =~ ^[0-9]+$ ]]; then
                limit=1
            fi
            
            # Conta processos sshd/dropbear do usuário
            conns=$(ps -ef | grep -E "sshd|dropbear" | grep -v grep | grep -w "$user" | wc -l)
            
            if [[ "$conns" -gt "$limit" ]]; then
                # Lista de pids mais novos acima do limite
                pids=$(ps -ef | grep -E "sshd|dropbear" | grep -v grep | grep -w "$user" | awk '{print $2}'  | sort -nr)
                to_kill=$((conns - limit))
                count=0
                for pid in $pids; do
                    if [[ $count -lt $to_kill ]]; then
                        kill -9 "$pid" 2>/dev/null
                        ((count++))
                    else
                        break
                    fi
                done
                logger -t fusion-limiter "Bloqueado multilogin de $user (Conexões: $conns, limite: $limit)"
            fi
        done < "$FUSION_DB"
    fi
    sleep 10
done
EOF
        chmod +x /usr/local/bin/fusion-limiter.sh
        
        echo -e "${C_YELLOW}Configurando unidade de serviço systemd...\n${C_NC}"
        cat <<'EOF' > /etc/systemd/system/fusion-limiter.service
[Unit]
Description=Fusion SSH Limitador Monitor Daemon
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/fusion-limiter.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
        systemctl daemon-reload 2>/dev/null
        systemctl enable fusion-limiter.service 2>/dev/null
        systemctl restart fusion-limiter.service 2>/dev/null
        
        echo -e "${C_GREEN}✓ Limiter Daemon instalado e ativo no systemd com maestria!${C_NC}"
    else
        echo -e "${C_RED}Procedimento cancelado.${C_NC}"
    fi
    read -p "Pressione Enter para prosseguir..."
}

# Otimização TCP BBR
optimize_throughput() {
    show_banner
    echo -e "${C_CYAN}🔥 SEÇÃO DE TUNEAMENTOS FUSION${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "${C_YELLOW}Aplicando otimização TCP BBR (Congestion Control) na rede do kernel...${C_NC}"
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
    echo -e "${C_GREEN}✓ TCP BBR habilitado e otimizado no kernel! Velocidade máxima de uploads.${C_NC}"
    read -p "Pressione Enter para voltar..."
}

# Bloqueio de torrent
enable_anti_torrent_only() {
    show_banner
    echo -e "${C_CYAN}🚫 CONFIGURAR BANIMENTO DE TORRENT (ANTI P2P)${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Deseja filtrar e dropar trackers de Torrent via IPTables? (s/n): " conf_t
    if [[ "$conf_t" == "s" || "$conf_t" == "S" ]]; then
        iptables -A FORWARD -p tcp --dport 6881:6889 -j DROP 2>/dev/null
        iptables -A FORWARD -p udp --dport 6881:6889 -j DROP 2>/dev/null
        iptables -t filter -A FORWARD -m string --string "peer_id=" --algo bm -j DROP 2>/dev/null
        iptables -t filter -A FORWARD -m string --string "info_hash" --algo bm -j DROP 2>/dev/null
        echo -e "${C_GREEN}✓ Regras IPTables anti-torrent injetadas com sucesso! VPS Protegida.${C_NC}"
        notify_telegram "🚫 *Proteção Anti-Torrent Ativada!*\\nRede P2P bloqueada no servidor."
    fi
    read -p "Pressione Enter para prosseguir..."
}

# Auto purge cron job switch
toggle_autopurge_cron() {
    show_banner
    echo -e "${C_CYAN}⏰ PURGE DIÁRIO AUTOMÁTICO DE CLIENTES EXPIRADOS${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "A varredura diária suspende contas do Linux de forma autônoma de 24h em 24h."
    echo ""
    if [[ -f "/etc/cron.daily/fusion-purge" ]]; then
        echo -e "Status @tual: ${C_GREEN}ATIVO E AGENDADO NO CRON DIÁRIO${C_NC}"
        read -p "Deseja desativar o auto-purge diário? (s/n): " c_purge
        if [[ "$c_purge" == "s" || "$c_purge" == "S" ]]; then
            rm -f /etc/cron.daily/fusion-purge
            echo -e "${C_RED}✓ Limpeza e travamento automático desativado.${C_NC}"
        fi
    else
        echo -e "Status @tual: ${C_RED}INATIVO / DESABILITADO${C_NC}"
        read -p "Deseja ativar o auto-purge diário no cron? (s/n): " c_purge
        if [[ "$c_purge" == "s" || "$c_purge" == "S" ]]; then
            cat <<'EOF' > /etc/cron.daily/fusion-purge
#!/bin/bash
FUSION_DB="/etc/fusion_users.db"
today_unix=$(date -d "$(date +%Y-%m-%d)" +%s)
while IFS='|' read -r user exp pwd || [ -n "$user" ]; do
    if [ -n "$user" ] && [ -n "$exp" ]; then
        exp_unix=$(date -d "$exp" +%s 2>/dev/null)
        if [ "$exp_unix" -le "$today_unix" ] 2>/dev/null; then
            usermod -L "$user" 2>/dev/null
        fi
    fi
done < "$FUSION_DB"
EOF
            chmod +x /etc/cron.daily/fusion-purge 2>/dev/null
            echo -e "${C_GREEN}✓ Auto-Purge diário programado com êxito administratório!${C_NC}"
        fi
    fi
    read -p "Pressione Enter para continuar..."
}

# Pasta 4: Ferramentas do Sistema
menu_sistema() {
    while true; do
        show_banner
        echo -e " ${C_PURPLE}📂 DIRETÓRIO: MENU PRINCIPAL > FERRAMENTAS DO SISTEMA${C_NC}"
        echo -e "${C_CYAN}╭──────────────────────────────────────────────────────────────────────────╮${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[1]${C_NC} 📈 Exibir Métricas e Recursos Reais da VPS                  ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[2]${C_NC} 🧹 Liberar Memória RAM Cache e Descartar Buffers           ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[3]${C_NC} 📝 Atualizar/Customizar Banner Superior                    ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[4]${C_NC} 🔔 Testar Alertas e Integração do Bot Telegram             ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}  ${C_CYAN}[5]${C_NC} 🔄 Reiniciar Host Linux VPS com Segurança                   ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}│${C_NC}                                                                          │"
        echo -e "${C_CYAN}│${C_NC}  ${C_RED}[0]${C_NC} ↩️ Voltar ao Painel Principal                               ${C_CYAN}│${C_NC}"
        echo -e "${C_CYAN}╰──────────────────────────────────────────────────────────────────────────╯${C_NC}"
        read -p "Selecione uma opção [0-5]: " opt_sis
        case $opt_sis in
            1) vps_metrics ;;
            2) clean_ram_cache ;;
            3) customize_banner_live ;;
            4) test_telegram_alert ;;
            5) reboot_server_safe ;;
            0) break ;;
            *) echo -e "${C_RED}Opção Inválida!${C_NC}"; sleep 1 ;;
        esac
    done
}

# Métricas reais da VPS
vps_metrics() {
    show_banner
    echo -e "${C_CYAN}📈 DETALHES DE RECURSOS VPS EM REAL TIME${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e "  Uso de Carga CPU:   ${C_WHITE}$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')%${C_NC}"
    echo -e "  Memória RAM Total:  ${C_WHITE}$(free -m | awk '/Mem:/ {print $3"/"$2" MB" }')${C_NC}"
    echo -e "  Espaço Disco (/):   ${C_WHITE}$(df -h / | tail -1 | awk '{print $3"/"$2" ocupado" }')${C_NC}"
    echo -e "  Conexões TCP Estab: ${C_GREEN}$(ss -t | grep -c ESTAB) sockets ativas${C_NC}"
    echo -e "----------------------------------------------------------------------"
    read -p "Pressione Enter para voltar ao painel..."
}

# Liberar memória cache
clean_ram_cache() {
    show_banner
    echo -e "${C_YELLOW}🧹 LIBERANDO MEMÓRIA RAM CACHE INDISPENSÁVEL...${C_NC}"
    sync
    echo 3 > /proc/sys/vm/drop_caches
    sleep 1.2
    echo -e "${C_GREEN}✓ Cache descartada! Velocidade e RAM disponíveis restauradas.${C_NC}"
    read -p "Pressione Enter para voltar..."
}

# Customiza banner superior em tempo de execução
customize_banner_live() {
    show_banner
    echo -e "${C_CYAN}📝 ALTERAR BANNER PERSONALIZADO SUPERIOR${C_NC}"
    echo -e "Banner @tual: ${C_YELLOW}$BANNER_TEXT${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Digite o novo texto do banner: " new_b
    if [[ -n "$new_b" ]]; then
        BANNER_TEXT="$new_b"
        echo -e "${C_GREEN}✓ Banner atualizado para: $BANNER_TEXT com sucesso!${C_NC}"
    else
        echo -e "${C_RED}Operação inválida.${C_NC}"
    fi
    sleep 1.5
}

# Teste Telegram
test_telegram_alert() {
    show_banner
    echo -e "${C_CYAN}🔔 TESTAR CONEXÃO TELEGRAM BOT${C_NC}"
    echo -e "----------------------------------------------------------------------"
    echo -e " - Configurado: \$( [[ "$TG_ENABLED" == "true" ]] && echo -e "${C_GREEN}Ativo${C_NC}" || echo -e "${C_RED}Desativado${C_NC}" )"
    echo -e " - Chat ID destino: ${C_YELLOW}$TG_CHAT_ID${C_NC}"
    echo ""
    if [[ "$TG_ENABLED" != "true" ]]; then
        echo -e "${C_RED}⚠️ Alertas estão desativados no script build.${C_NC}"
    fi
    read -p "Deseja forçar uma conexão teste agora? (s/n): " force_test
    if [[ "$force_test" == "s" || "$force_test" == "S" ]]; then
        echo -e "${C_YELLOW}Disparando mensagem HTTP......${C_NC}"
        local res=$(curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" \
            -d "chat_id=$TG_CHAT_ID" \
            -d "text=🔔 [FUZION TEST ALERT]: Conectividade ativada com êxito sob a VPS \$(hostname)!" \
            -d "parse_mode=Markdown")
            
        if echo "$res" | grep -q "ok\":true"; then
            echo -e "${C_GREEN}✓ Alerta enviado com sucesso ao Telegram!${C_NC}"
        else
            echo -e "${C_RED}✖ Erro no response da API:${C_NC}"
            echo -e "${C_WHITE}$res${C_NC}"
        fi
    fi
    read -p "Pressione Enter para prosseguir..."
}

# Reiniciar servidor com segurança
reboot_server_safe() {
    show_banner
    echo -e "${C_RED}⚠️ INSTABILIDADE: VOCÊ SOLICITOU REBOOT DO SISTEMA!${C_NC}"
    echo "----------------------------------------------------------------------"
    read -p "Confirma que deseja reiniciar a VPS agora de imediato? (s/n): " c_reboot
    if [[ "$c_reboot" == "S" || "$c_reboot" == "s" ]]; then
        echo -e "${C_YELLOW}✓ Enviando reboot seguro... Desconectando em 3 segundos!${C_NC}"
        notify_telegram "🔄 *Servidor Linux VPS sendo Reiniciado por Fuzion!*"
        sleep 3
        reboot
    fi
}

# Inicialização automática se configurado de fábrica
if [[ "$FLAG_AUTO_PURGE" == "true" ]]; then
    # Cria o cronjob automático de auto purge diário se não existir
    if [[ ! -f "/etc/cron.daily/fusion-purge" ]]; then
        cat <<'EOF' > /etc/cron.daily/fusion-purge
#!/bin/bash
FUSION_DB="/etc/fusion_users.db"
today_unix=$(date -d "$(date +%Y-%m-%d)" +%s)
while IFS='|' read -r user exp pwd || [ -n "$user" ]; do
    if [ -n "$user" ] && [ -n "$exp" ]; then
        exp_unix=$(date -d "$exp" +%s 2>/dev/null)
        if [ "$exp_unix" -le "$today_unix" ] 2>/dev/null; then
            usermod -L "$user" 2>/dev/null
        fi
    fi
done < "$FUSION_DB"
EOF
        chmod +x /etc/cron.daily/fusion-purge 2>/dev/null
    fi
fi

# Inicializa o console
main_menu
