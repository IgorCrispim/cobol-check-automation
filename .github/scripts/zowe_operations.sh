#!/bin/bash
# zowe_operations.sh

# Converte o nome de utilizador para minúsculas
# A variável ZOWE_USER_FOR_SCRIPT é passada pelo ficheiro de workflow
LOWERCASE_USERNAME=$(echo "$ZOWE_USER_FOR_SCRIPT" | tr '[:upper:]' '[:lower:]')
TARGET_DIR="/z/$LOWERCASE_USERNAME/cobolcheck"

# Os comandos Zowe irão usar os perfis 'default' criados no workflow
echo "Verificando se o diretório $TARGET_DIR existe..."
if ! zowe zos-files list uss-files "$TARGET_DIR" &>/dev/null; then
  echo "Diretório não existe. Criando..."
  zowe zos-files create uss-directory "$TARGET_DIR"
else
  echo "Diretório já existe."
fi

echo "A fazer o upload dos ficheiros do COBOL Check..."
zowe zos-files upload dir-to-uss "./cobol-check" "$TARGET_DIR" --recursive --binary-files "*.jar"

echo "Verificando o upload:"
zowe zos-files list uss-files "$TARGET_DIR"
