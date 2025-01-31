# Caminhos locais
CAMINHO_SUITES="/home/laisdev/Documentos/robotframework/TestMagazineLuiza/suites"
CAMINHO_RESULTADOS="/home/laisdev/Documentos/robotframework/TestMagazineLuiza/suites/results"

# Nome da imagem
IMAGEM="testwithrobot:latest"

# Caminho do volume de resultados
RESULTADOS_ATUAIS="$CAMINHO_RESULTADOS"

# Executa o contêiner e roda os testes, removendo o contêiner após a execução
docker run \
  --rm \
  --name testsrobot \
  -v "$CAMINHO_SUITES:/opt/robotframework/suites/testes" \
  -v "$RESULTADOS_ATUAIS:/opt/robotframework/results" \
  "$IMAGEM"

echo "Testes concluídos! Resultados salvos em: $RESULTADOS_ATUAIS"
