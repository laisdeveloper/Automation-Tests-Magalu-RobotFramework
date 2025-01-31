*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados à busca do site Magazine Luiza.

Resource                                 ../../resource.robot

*** Variables ***
${SEARCH_BUTTON_TEXT}                                                //svg[@aria-label='Buscar produto']
${SEARCH_TEXT}                                                       //input[contains(@type,'search')]
${SEARCH_FILTER}                                                     //input[contains(@placeholder,'Busque por ')]
${SEARCH_MARCA}                                                      //p[@data-testid='main-title'][contains(.,'Marca')]


*** Keywords ***
# Pode ser de login, "Ofertas do dia"
Quando ele acessa a página "${PAGE}"
    Log                                                              Acesando a página "${PAGE}"
    Entrar na página "${PAGE}" 

Quando ele busca pelo produto "${SEARCH_NAME}"
    Log                                                              Pesquisando pelo produto "${SEARCH_NAME}"
    Digitar nome "${SEARCH_NAME}" no campo de busca
    Clicar no botao de busca

E aplica o filtro pela marca
    [Arguments]                                                      @{LIST_PRODUCTS}
    Verifica se o filtro de marcas está visível
    Log                                                              Aplicando filtro pela marca, para cada produto.
    FOR    ${LIST_PRODUCTS}            IN                            @{LIST_PRODUCTS}
        Log                                                          Filtrando pela marca.
        Filtrar a marca ${LIST_PRODUCTS}
        Log                                                          Limpando o campo de busca...
        Clear Element Text                                           ${SEARCH_FILTER}
        Sleep                                                        ${TIMEOUT_SLEEP}
    END


Então devem ser exibidos somente produtos das marcas 
    [Arguments]                                                      @{LIST_PRODUCTS}
    FOR    ${LIST_PRODUCTS}            IN                            @{LIST_PRODUCTS}
        Log                                                          Verificando se o produto ${LIST_PRODUCTS} está na página.
        Page Should Contain                                          ${LIST_PRODUCTS}
        Log                                                          O produto ${LIST_PRODUCTS} foi encontrado na pagina.
    END


Então o produto "${PRODUCT}" deve aparecer nos resultados da pesquisa
    Verificar se esta listando o produto "${PRODUCT}"


# Keywords Complementares
# Botao de busca
Clicar no botao de ${WHERE}
    # IF   $WHERE == 'busca'
        Log                                                          Verificando se o botão de pesquisa está visível.
        ${SEARCH_IS_VISIBLE}    Run Keyword And Return Status        Element Should Be Visible    ${SEARCH_BUTTON}
        IF    ${SEARCH_IS_VISIBLE}
            Log                                                      Botão de pesquisa encontrado. Clicando no botão.
            Click Element                                            ${SEARCH_BUTTON} 
        ELSE
            Log                                                      Botão de pesquisa não encontrado. Pressionando Enter.
            Press Keys                                     NONE                                                                                        RETURN
        END
    # ELSE IF   $WHERE == 'filtro'
    #     Press Keys                           NONE                                         RETURN
    # END

# Entrar na pagina de "Ofertas do Dia", ou de login
Entrar na página "${PAGE}"
    Log                                                              Clicando no elemento que direciona para a página "${PAGE}"
    Click Element                                                    //a[@data-testid='link'][contains(.,'${PAGE}')]
    Log     ${PAGE}
    Log                                                              Verificando se a URL atual contém a parte esperada: ${PAGE}
    ${CURRENT_URL}    Get Location   
    ${LOWER_STRING}    Convert To Lowercase    ${PAGE}
    ${PAGE_UPDATED}    removing_spaces    ${LOWER_STRING}   
    Log                                                              Verificando se a URL atual contém a parte esperada: ${PAGE_UPDATED}
    Should Contain    ${CURRENT_URL}    ${PAGE_UPDATED}              A URL atual não contém a parte esperada: ${PAGE_UPDATED}.

Filtrar a marca ${LIST_PRODUCTS}
    Digitar nome "${LIST_PRODUCTS}" no campo de filtro
    Log                                                              Verifica se o filtro esta visível na pagina.
    ${LIST_PRODUCTS_IS_VISIBLE}    Run Keyword And Return Status     Wait Until Element Is Visible    xpath=//li[@data-testid='filter-checkbox'][contains(.,'${LIST_PRODUCTS}')]     timeout=${TIMEOUT} 
    IF   ${LIST_PRODUCTS_IS_VISIBLE}
        Log                                                          Filtro encontrado. 
        Click Element                                                (//li[@data-testid='filter-checkbox'][contains(.,'${LIST_PRODUCTS}')])[1]
        Wait Until Page Contains Element                             //div[@class='sc-fqkvVR hrwhWM'][contains(.,'${LIST_PRODUCTS}')]                     timeout=${TIMEOUT} 
    ELSE
        Pass execution                                               Filtro não encontrado. Pulando para o proximo elemento.
    END

Verifica se o filtro de marcas está visível
    Log                                                              Verifica se o filtro de marcas está visível na página.
    Wait Until Page Contains Element                                 ${SEARCH_MARCA}                                                                       timeout=${TIMEOUT}

Verificar se esta listando o produto "${PRODUCT}"
    ${NAME_PRODUCT}                                                  Convert To Lowercase                                                                  ${PRODUCT}
    Log                                                              Verificando se o produto ${NAME_PRODUCT} está na página.
    Wait Until Page Contains                                         ${NAME_PRODUCT}                                                                       timeout=${TIMEOUT}
    # Scroll Element Into View                                       //h1[@data-testid='main-title'][contains(.,'${NAME_PRODUCT}')]
    Wait Until Page Contains Element                                 //h1[@data-testid='main-title'][contains(.,'${NAME_PRODUCT}')]                        timeout=${TIMEOUT}

Digitar nome "${SEARCH_NAME}" no campo de ${WHERE}
    IF    $WHERE == 'busca'
        Log    Digitar nome "${SEARCH_NAME}" no campo de busca
        Input Text                                  locator=${SEARCH_TEXT}                                                                                 text=${SEARCH_NAME}
    ELSE IF    $WHERE == 'filtro'
        Log    Digitar nome "${SEARCH_NAME}" no campo de filtro
        Input Text                                  locator=${SEARCH_FILTER}                                                                               text=${SEARCH_NAME}
    END
