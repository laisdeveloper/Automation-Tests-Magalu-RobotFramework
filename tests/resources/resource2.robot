*** Settings ***
Documentation           Este arquivo contém as keywords para validar passos para compra do site Magazine Luiza
...                     Autor: Lais Coutinho

Library                 SeleniumLibrary
Library                 String
Library                 BuiltIn
Library                 ./libraries/formatString.py

Resource                ./PageObjects/Home/Home.robot
Resource                ./PageObjects/Cart/Cart.robot
Resource                ./PageObjects/Delivery/Delivery.robot
Resource                ./PageObjects/Login/Login.robot
Resource                ./PageObjects/Search/Search.robot

*** Variables ***
${BROWSER}                               headlesschrome
${TIMEOUT}                               20s
${TIMEOUT_SLEEP}                         3s    

*** Keywords ***
# Setup e Teardown
Abrir navegador
    Open Browser                                    browser=${BROWSER}    
    Maximize Browser Window
    Log                                             Navegador aberto com sucesso.

Fechar navegador
    Close Browser
    Log                                             Navegador fechado com sucesso.

# Keywords Granularizadas
Digitar nome "${SEARCH_NAME}" no campo de ${WHERE}
    IF    $WHERE == 'busca'
        Log    Digitar nome "${SEARCH_NAME}" no campo de busca
        Input Text                                  locator=${SEARCH_TEXT}                                                                      text=${SEARCH_NAME}
    ELSE IF    $WHERE == 'filtro'
        Log    Digitar nome "${SEARCH_NAME}" no campo de filtro
        Input Text                                  locator=${SEARCH_FILTER}                                                                    text=${SEARCH_NAME}
    END
