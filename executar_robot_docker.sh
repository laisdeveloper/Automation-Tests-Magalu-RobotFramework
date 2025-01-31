#!/bin/bash

# Caminhos locais
CAMINHO_SUITES="/home/laisdev/Documentos/robotframework/TestMagazineLuiza/suites"
CAMINHO_RESULTADOS="/home/laisdev/Documentos/robotframework/TestMagazineLuiza/results"

# Nome da imagem
IMAGEM="testwithrobot:latest"

# Verifica se os diretórios existem
if [ ! -d "$CAMINHO_SUITES" ]; then
  echo "Erro: O diretório de testes '$CAMINHO_SUITES' não existe."
  exit 1
fi

if [ ! -d "$CAMINHO_RESULTADOS" ]; then
  echo "O diretório de resultados '$CAMINHO_RESULTADOS' não existe. Criando..."
  mkdir -p "$CAMINHO_RESULTADOS"
fi

# Executa o contêiner e roda os testes
docker run --rm \
  --name execucao_robot \
  -v "$CAMINHO_SUITES:/opt/robotframework/suites" \
  -v "$CAMINHO_RESULTADOS:/opt/robotframework/results" \
  "$IMAGEM" \
  robot --outputdir /opt/robotframework/results /opt/robotframework/suites
