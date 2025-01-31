# Imagem base
FROM ubuntu:20.04

# Definir a variável de ambiente para evitar prompts do apt
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    xvfb \
    wget \
    unzip \
    libx11-6 \
    gnupg \
    curl && \
    apt-get clean

# Instalar o Google Chrome (última versão estável)
RUN wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-linux-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    apt-get clean

# Baixar uma versão fixa do ChromeDriver
RUN wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Instalar Robot Framework e SeleniumLibrary
RUN pip3 install robotframework robotframework-seleniumlibrary

# Configurar diretórios para testes e resultados
RUN mkdir -p /opt/robotframework/suites /opt/robotframework/results

# Volumes para compartilhar testes e resultados com o host
VOLUME /opt/robotframework/suites
VOLUME /opt/robotframework/results

# Configurar o Xvfb (servidor gráfico)
ENV DISPLAY=:99

# Definir diretório de trabalho
WORKDIR /opt/robotframework

# Comando padrão para executar os testes
CMD ["robot", "--outputdir", "/opt/robotframework/results", "/opt/robotframework/suites"]
