#!/bin/bash
# mainframe_operations.sh

# Configura o ambiente Java no USS
export PATH=$PATH:/usr/lpp/java/J8.0_64/bin
export JAVA_HOME=/usr/lpp/java/J8.0_64

# Verifica se o Java está disponível
java -version

# Obtém o nome de usuário (será passado pelo workflow)
# A linha abaixo é um exemplo do script original, mas nosso workflow já define a variável
# ZOWE_USERNAME="z99998" 

# Navega para o diretório onde o cobol-check foi upado
cd cobolcheck
echo "Mudei para o diretório $(pwd)"

# Torna o programa cobolcheck executável
chmod +x cobolcheck
echo "Tornei o cobolcheck executável"

# Torna o script de execução de testes executável
cd scripts
chmod +x linux_gnucobol_run_tests
echo "Tornei o linux_gnucobol_run_tests executável"
cd .. # Volta para a pasta cobolcheck

# Função para executar o cobolcheck para um programa específico
run_cobolcheck() {
    program=$1
    echo "Executando cobolcheck para o programa $program"

    # Executa o cobolcheck. O comando pode gerar exceções, mas o script continuará
    ./cobolcheck -p $program
    echo "Execução do Cobolcheck concluída para $program (exceções podem ter ocorrido)"

    # Verifica se o arquivo de teste foi criado
    if [ -f "CC##99.CBL" ]; then
        # Copia o arquivo de teste para o dataset PDS no MVS
        if cp CC##99.CBL "//'$ZOWE_USERNAME.CBL($program)'"; then
            echo "Copiei CC##99.CBL para $ZOWE_USERNAME.CBL($program)"
        else
            echo "Falha ao copiar CC##99.CBL para $ZOWE_USERNAME.CBL($program)"
        fi
    else
        echo "Arquivo CC##99.CBL não encontrado para o programa $program"
    fi

    # Copia o arquivo JCL correspondente, se ele existir no repositório
    if [ -f "${program}.JCL" ]; then
        if cp "${program}.JCL" "//'$ZOWE_USERNAME.JCL($program)'"; then
            echo "Copiei ${program}.JCL para $ZOWE_USERNAME.JCL($program)"
        else
            echo "Falha ao copiar ${program}.JCL para $ZOWE_USERNAME.JCL($program)"
        fi
    else
        echo "Arquivo ${program}.JCL não encontrado"
    fi
}

# Executa a função para cada programa que queremos testar
for program in NUMBERS EMPPAY DEPTPAY; do
    run_cobolcheck $program
done

echo "Operações no mainframe concluídas"
