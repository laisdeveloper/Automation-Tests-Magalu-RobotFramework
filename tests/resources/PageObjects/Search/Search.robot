*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados à busca do site Magazine Luiza.

# Resource                ../Home/Home.robot
# Resource                ../Cart/Cart.robot
# Resource                ../Delivery/Delivery.robot
# Resource                ../Login/Login.robot
# Resource                ../Search/Search.robot


*** Variables ***
${SEARCH_BUTTON_TEXT}                    //svg[@aria-label='Buscar produto']
${SEARCH_TEXT}                           //input[contains(@type,'search')]
${SEARCH_FILTER}                         //input[contains(@placeholder,'Busque por ')]
${SEARCH_MARCA}                          //p[@data-testid='main-title'][contains(.,'Marca')]


*** Keywords ***
Quando ele acessa a página "${PAGE}"
    Entrar na página "${PAGE}" 


E aplica o filtro pela marca
    [Arguments]                                             @{LIST_PRODUCTS}
    Verifica se o filtro de marcas está visível
    FOR    ${LIST_PRODUCTS}            IN                   @{LIST_PRODUCTS}
        Filtrar a marca ${LIST_PRODUCTS}
        Clear Element Text                                  ${SEARCH_FILTER}
        Sleep                                               ${TIMEOUT_SLEEP}
    END


Então devem ser exibidos somente produtos das marcas 
    [Arguments]                                             @{LIST_PRODUCTS}
    FOR    ${LIST_PRODUCTS}            IN                   @{LIST_PRODUCTS}
        Page Should Contain                                 ${LIST_PRODUCTS}
        Log                                                 O produto ${LIST_PRODUCTS} foi encontrado na pagina.
    END


Então o produto "${PRODUCT}" deve aparecer nos resultados da pesquisa
    Verificar se esta listando o produto "${PRODUCT}"



# Keywords Complementares
Entrar na página "${PAGE}"
    Click Element                                            //a[@data-testid='link'][contains(.,'${PAGE}')]
    Log     ${PAGE}
    ${CURRENT_URL}    Get Location   
    ${LOWER_STRING}    Convert To Lowercase    ${PAGE}
    ${PAGE_UPDATED}    removing_spaces    ${LOWER_STRING}   
    Should Contain    ${CURRENT_URL}    ${PAGE_UPDATED}      A URL atual não contém a parte esperada: ${PAGE_UPDATED}.

Filtrar a marca ${LIST_PRODUCTS}
    Digitar nome "${LIST_PRODUCTS}" no campo de filtro
    # Clicar no botao de filtro
    ${LIST_PRODUCTS_IS_VISIBLE}    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//li[@data-testid='filter-checkbox'][contains(.,'${LIST_PRODUCTS}')]     timeout=${TIMEOUT} 
    IF   ${LIST_PRODUCTS_IS_VISIBLE}
        Log                                          Filtro encontrado. 
        Click Element                                (//li[@data-testid='filter-checkbox'][contains(.,'${LIST_PRODUCTS}')])[1]
        # para recarregar o DOM da pagina
        Wait Until Page Contains Element             //div[@class='sc-fqkvVR hrwhWM'][contains(.,'${LIST_PRODUCTS}')]                                       timeout=${TIMEOUT} 
    ELSE
        Pass execution                               Filtro não encontrado. Pulando para o proximo elemento.
    END

Verifica se o filtro de marcas está visível
    Wait Until Page Contains Element                 ${SEARCH_MARCA}     timeout=${TIMEOUT}

Verificar se esta listando o produto "${PRODUCT}"
    ${NAME_PRODUCT}    Convert To Lowercase    ${PRODUCT}
    Wait Until Page Contains Element                        ${NAME_PRODUCT}        timeout=${TIMEOUT}
    Scroll Element Into View                                //h1[@data-testid='main-title'][contains(.,'${NAME_PRODUCT}')]
    Wait Until Page Contains Element                        //h1[@data-testid='main-title'][contains(.,'${NAME_PRODUCT}')]        timeout=${TIMEOUT}