#!/bin/bash
# zowe_operations.sh

# Converte o nome de utilizador para minúsculas
LOWERCASE_USERNAME=$(echo "$ZOWE_CLI_USER" | tr '[:upper:]' '[:lower:]')

# Verifica se o diretório existe, cria se não existir
# O Zowe CLI irá usar as variáveis de ambiente (ZOWE_CLI_HOST, etc.) para a conexão
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Diretório não existe. Criando..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck"
else
  echo "Diretório já existe."
fi

# Faz o upload dos ficheiros
echo "A fazer o upload dos ficheiros do COBOL Check..."
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive \
  --binary-files "*.jar"

# Verifica o upload
echo "Verificando o upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"

