#!/bin/bash
# mainframe_operations.sh

# Configura o ambiente
export PATH=$PATH:/usr/lpp/java/J8.0_64/bin
export JAVA_HOME=/usr/lpp/java/J8.0_64

# Muda para o diretório do cobolcheck
cd cobolcheck
echo "Mudei para $(pwd)"

# Torna o cobolcheck executável
chmod +x cobolcheck

# Função para executar o cobolcheck e copiar os ficheiros
run_cobolcheck() {
    program=$1
    echo "A executar cobolcheck para $program"
    ./cobolcheck -p $program

    echo "Execução do Cobolcheck concluída para $program"

    # Copia o resultado para o dataset MVS
    if [ -f "CC##99.CBL" ]; then
        cp CC##99.CBL "//'${ZOWE_USER_FOR_SCRIPT}.CBL($program)'"
        echo "Copiei CC##99.CBL para ${ZOWE_USER_FOR_SCRIPT}.CBL($program)"
    else
        echo "CC##99.CBL não encontrado para $program"
    fi

    # Copia o ficheiro JCL
    if [ -f "${program}.JCL" ]; then
        cp "${program}.JCL" "//'${ZOWE_USER_FOR_SCRIPT}.JCL($program)'"
        echo "Copiei ${program}.JCL para ${ZOWE_USER_FOR_SCRIPT}.JCL($program)"
    else
        echo "${program}.JCL não encontrado"
    fi
}

# Executa para cada programa
for program in NUMBERS EMPPAY DEPTPAY; do
    run_cobolcheck $program
done

echo "Operações no mainframe concluídas"
