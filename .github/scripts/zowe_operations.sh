#!/bin/bash
# zowe_operations.sh

# Converte o nome de utilizador para minúsculas
LOWERCASE_USERNAME=$(echo "$ZOWE_CLI_USER" | tr '[:upper:]' '[:lower:]')

# Define as opções de conexão para usar em todos os comandos Zowe
# As variáveis (ZOWE_CLI_HOST, etc.) vêm do ficheiro main.yml
CONN_OPTS="--host $ZOWE_CLI_HOST --port $ZOWE_CLI_PORT --user $ZOWE_CLI_USER --password $ZOWE_CLI_PASSWORD"

# Verifica se o diretório existe, cria se não existir
# A opção --sshs-fingerprint-check false é para evitar prompts de confirmação de SSH
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $CONN_OPTS --sshs-fingerprint-check false &>/dev/null; then
  echo "Diretório não existe. Criando..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck" $CONN_OPTS --sshs-fingerprint-check false
else
  echo "Diretório já existe."
fi

# Faz o upload dos ficheiros
echo "A fazer o upload dos ficheiros do COBOL Check..."
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive \
  --binary-files "*.jar" $CONN_OPTS --sshs-fingerprint-check false

# Verifica o upload
echo "Verificando o upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $CONN_OPTS --sshs-fingerprint-check false

