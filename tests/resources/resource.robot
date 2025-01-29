*** Settings ***
Documentation           Este arquivo contém as keywords para validar passos para compra do site Magazine Luiza
...                     Autor: Lais Coutinho

Library                 SeleniumLibrary
Library                 String

# Resource                ./PageObjects/Home.robot
# Resource                ./PageObjects/Cart.robot
# Resource                ./PageObjects/Search.robot
# Resource                ./PageObjects/Offers.robot
# Resource                ./PageObjects/Login.robot
# Resource                ./PageObjects/Buy.robot

*** Variables ***
${BROWSER}              chrome
${HOME_URL}             https://www.magazineluiza.com.br
${HEADER}               Magazine Luiza | Pra você é Magalu!
${SEARCH_BUTTON_TEXT}        //svg[@aria-label='Buscar produto']
${SEARCH_TEXT}          //input[contains(@type,'search')]
${SEARCH_FILTER}        //input[contains(@placeholder,'Busque por ')]
${SEARCH_BUTTON_FILTER} 
# ${}

*** Keywords ***
# Setup e Teardown
Abrir navegador
    Open Browser                            browser=${BROWSER}        
    Maximize Browser Window

Fechar navegador
    Close Browser

# Keywords Granularizadas
Acessar página inicial do site Magazine Luiza
    Go To                                    ${HOME_URL}

Verificar se o header da pagina é ${HEADER}
    Wait Until Page Contains Element        //title[@data-testid='link-0'][contains(.,'${HEADER}')]

Digitar nome "${SEARCH_NAME}" no campo de ${WHERE}
    IF    $WHERE == 'busca'
        Log    Digitar nome "${SEARCH_NAME}" no campo de busca
        Input Text                               locator=${SEARCH_TEXT}                                text=${SEARCH_NAME}
    ELSE IF    $WHERE == 'filtro'
        Log    Digitar nome "${SEARCH_NAME}" no campo de filtro
        Input Text                               locator=${SEARCH_FILTER}                              text=${SEARCH_NAME}
    END

Clicar no botao de ${WHERE}
    # IF   $WHERE == 'busca'
        ${SEARCH_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_BUTTON}
        IF    ${SEARCH_IS_VISIBLE}
            Log    Botão de pesquisa encontrado. Clicando no botão.
            Click Element                        ${SEARCH_BUTTON} 
        ELSE
            Log    Botão de pesquisa não encontrado. Pressionando Enter.
            Press Keys                           NONE                                         RETURN
        END
    # ELSE IF   $WHERE == 'filtro'
    #     Press Keys                           NONE                                         RETURN
    # END

Verificar se o resultado da pesquisa esta listando o produto "${PRODUCT}"
    Log        ${PRODUCT}
    Wait Until Page Contains Element        //h1[@data-testid='main-title'][contains(.,'${PRODUCT}')]

Verifica se o filtro de marcas está visível
    Wait Until Page Contains Element               //p[@data-testid='main-title'][contains(.,'Marca')]

Filtrar a marca ${LIST_PRODUCTS}
    Digitar nome "${LIST_PRODUCTS}" no campo de filtro
    # Clicar no botao de filtro
    ${LIST_PRODUCTS_IS_VISIBLE}    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//li[@data-testid='filter-checkbox'][contains(.,'${LIST_PRODUCTS}')]
    IF   ${LIST_PRODUCTS_IS_VISIBLE}
        Log    Filtro encontrado. 
        Click Element                               (//li[@data-testid='filter-checkbox'][contains(.,'${LIST_PRODUCTS}')])[1]
    ELSE
        Log    Filtro não encontrado.
        Pass execution
    END


# Home
Dado que o usuário está na página inicial da Magazine Luiza
    [Tags]                                  HomeMagalu
    Acessar página inicial do site Magazine Luiza
    Verificar se o header da pagina é ${HEADER}

Quando ele busca pelo produto "${SEARCH_NAME}"
    [Tags]                                  SearchProduct
    Digitar nome "${SEARCH_NAME}" no campo de busca
    Clicar no botao de busca

# Search
Então o produto "${PRODUCT}" deve aparecer nos resultados da pesquisa
    [Tags]                                          ProductInSearch
    ${PRODUCT_UPDATED}    Convert To Lowercase      ${PRODUCT}
    Verificar se o resultado da pesquisa esta listando o produto "${PRODUCT_UPDATED}"

E aplica os filtros pelas marcas 
    [Arguments]                                     @{LIST_PRODUCTS}
    Verifica se o filtro de marcas está visível
    FOR    ${LIST_PRODUCTS}            IN           @{LIST_PRODUCTS}
        Filtrar a marca ${LIST_PRODUCTS}
        Clear Element Text                          ${SEARCH_FILTER}
    END

Então devem ser exibidos somente produtos das marcas 
    [Arguments]                                     @{LIST_PRODUCTS}
    ${TEXT_LIST_GROUP}                 Join         ${LIST_PRODUCTS}
    Log                                             ${TEXT_LIST_GROUP}
    Page Should Contain Element        //div[@class='sc-fqkvVR hrwhWM'][contains(.,'${TEXT_LIST_GROUP}')]
    