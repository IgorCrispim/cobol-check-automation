#!/bin/bash

# zowe_operations.sh

# Converte o nome de usuário para minúsculas para criar o caminho do diretório
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Verifica se o diretório existe no mainframe e, se não, o cria
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Diretório não existe. Criando..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck"
else
  echo "Diretório já existe."
fi

# Faz o upload da pasta 'cobol-check' do repositório para o diretório no mainframe
# A opção --binary-files garante que o arquivo .jar não seja corrompido
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "*.jar"

# Verifica se o upload foi bem-sucedido listando os arquivos no mainframe
echo "Verificando upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
