#!/bin/bash

# ==============================================================================
# CONFIGURAÇÕES
# ==============================================================================
VERSAO="v1.0.0"
ARQUIVO_ZIP="jre1.8.0_171.tar.gz.zip"
ARQUIVO_TAR="jre1.8.0_171.tar.gz"
URL_DOWNLOAD="https://github.com/fiuzafelipe/Raphanet-utilitarios/releases/download/${VERSAO}/${ARQUIVO_ZIP}"
DIR_INSTALACAO="/usr"
DIR_JRE="${DIR_INSTALACAO}/jre1.8.0_171"

# Captura o caminho absoluto deste script para auto-exclusão no final
CAMINHO_SCRIPT="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# ==============================================================================
# CORES PARA O TERMINAL
# ==============================================================================
CYAN='\033[0;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # Sem Cor

# ==============================================================================
# VERIFICAÇÃO DE PRIVILÉGIOS (ROOT)
# ==============================================================================
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[ERRO] Este script precisa de permissões de administrador.${NC}"
  echo -e "${YELLOW}Por favor, execute usando: sudo $0${NC}"
  exit 1
fi

clear
echo -e "${CYAN}==========================================================${NC}"
echo -e "${CYAN}        FIUZA TECHNOLOGY - INSTALADOR JRE (PDV)           ${NC}"
echo -e "${CYAN}==========================================================${NC}"
echo ""

# 1. Download com trava de erro e ignorando SSL
echo -e "${YELLOW}[1/4] Baixando pacote JRE...${NC}"
cd "$DIR_INSTALACAO" || exit

# Usando --no-check-certificate para PDVs com certificados raiz desatualizados
# e -q para manter a interface limpa
if ! wget -q --no-check-certificate -O "$ARQUIVO_ZIP" "$URL_DOWNLOAD"; then
    echo -e "${RED}[ERRO] Falha ao baixar o arquivo. Verifique a conexão ou o link da release.${NC}"
    exit 1
fi

# 2. Extração dos arquivos com trava de erro
echo -e "${YELLOW}[2/4] Extraindo arquivos (ZIP e TAR)...${NC}"
if ! unzip -q "$ARQUIVO_ZIP"; then
    echo -e "${RED}[ERRO] Falha ao extrair o arquivo ZIP. O download pode ter corrompido.${NC}"
    rm -f "$ARQUIVO_ZIP"
    exit 1
fi
rm -f "$ARQUIVO_ZIP"

if ! tar -xzf "$ARQUIVO_TAR"; then
    echo -e "${RED}[ERRO] Falha ao extrair o arquivo TAR.${NC}"
    rm -f "$ARQUIVO_TAR"
    exit 1
fi
rm -f "$ARQUIVO_TAR"

# 3. Criação dos links simbólicos
echo -e "${YELLOW}[3/4] Configurando links simbólicos no sistema...${NC}"
cd /usr/bin || exit
ln -sf "${DIR_JRE}/bin/java" /usr/bin/java
ln -sf "${DIR_JRE}/bin/javaws" /usr/bin/javaws

echo -e "${GREEN}[4/4] Instalação do Java concluída com sucesso!${NC}"
echo ""

# ==============================================================================
# FINALIZAÇÃO E AUTO-EXCLUSÃO
# ==============================================================================
echo -e "${CYAN}==========================================================${NC}"
echo -n -e "${YELLOW}Deseja reiniciar o PDV agora? (Y/N): ${NC}"
read -n 1 -r resposta
echo "" # Pula linha

# Exclui o script .sh silenciosamente antes de finalizar
rm -f "$CAMINHO_SCRIPT"

# Valida se a tecla pressionada foi Y ou y
if [[ "$resposta" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Iniciando reboot do sistema...${NC}"
    sleep 2
    reboot
else
    echo -e "${CYAN}Operação finalizada. O instalador foi apagado, mas o sistema não foi reiniciado.${NC}"
    exit 0
fi