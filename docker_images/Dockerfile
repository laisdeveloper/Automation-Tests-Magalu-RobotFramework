FROM selenium/standalone-chrome:latest

# Instalando Python e dependências do Robot Framework
USER root
RUN apt-get update && \
apt-get install -y python3 python3-venv && \
python3 -m venv /opt/venv && \
/opt/venv/bin/pip install --upgrade pip && \
/opt/venv/bin/pip install robotframework selenium robotframework-seleniumlibrary

# Variáveis de ambiente
ENV PATH="/opt/venv/bin:$PATH"
ENV CHROME_BIN=/usr/bin/google-chrome-stable
ENV DISPLAY=:99
ENV ROBOT_OUTPUTDIR=/opt/robotframework/results
ENV ROBOT_TESTSDIR=/opt/robotframework/suites/tests
ENV CHROME_OPTIONS=--user-data-dir=/opt/robotframework/user-data

# Diretórios de resultados e testes
VOLUME /opt/robotframework/results
VOLUME /opt/robotframework/suites/tests

# Comando para rodar os testes
CMD ["/bin/bash", "-c", "\
mkdir -p $ROBOT_OUTPUTDIR && \
mkdir -p /opt/robotframework/user-data && \
robot --variable CHROME_OPTIONS:$CHROME_OPTIONS --outputdir $ROBOT_OUTPUTDIR $ROBOT_TESTSDIR"]