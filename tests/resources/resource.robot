*** Settings ***
Documentation           Este arquivo contém as keywords para validar passos para compra do site Magazine Luiza
...                     Autor: Lais Coutinho

Library                 SeleniumLibrary
Library                 String
Library                 BuiltIn
Library                 ./libraries/formatString.py

# Resource                ./PageObjects/Home.robot
# Resource                ./PageObjects/Cart.robot
# Resource                ./PageObjects/Search.robot
# Resource                ./PageObjects/Offers.robot
# Resource                ./PageObjects/Login.robot
# Resource                ./PageObjects/Buy.robot

*** Variables ***
${BROWSER}                               chrome
${TIMEOUT}                               4s
${HOME_URL}                              https://www.magazineluiza.com.br
${HOME_HEADER}                           Magazine Luiza | Pra você é Magalu!
${SEARCH_BUTTON_TEXT}                    //svg[@aria-label='Buscar produto']
${SEARCH_TEXT}                           //input[contains(@type,'search')]
${SEARCH_FILTER}                         //input[contains(@placeholder,'Busque por ')]
${SEARCH_MARCA}                          //p[@data-testid='main-title'][contains(.,'Marca')]
${CART_BUTTON_ADD}                       (//button[@color='secondary'][contains(.,'Adicionar à Sacola')])[1]
${CART_NOT_PROTECTION}                   //strong[contains(.,'"Incluir proteção"')]
${CART_BUTTON_NOT_PROTECTION}            //button[@color='secondary'][contains(.,'Agora não')]
${CART_BUTTON_REMOVE_ITEM}               //span[@class='BasketItem-delete-label'][contains(.,'Excluir')]
${CART_VERIFICATION_IS_EMPTY}            //div[@class='EmptyBasket-title'][contains(.,'Sua sacola está vazia')]
${CART_QUANTITY_ITEM_PRODUCT}            //select[contains(@class,'BasketItemProduct-quantity-dropdown')]
${LOGIN_VERIFICATION_SUCESS}             //div[@class='sc-ggqIjW jRnSmj'][contains(.,'Olá, ')]
${LOGIN_VERIFICATION_FAIL}               //div[@class='sc-ggqIjW jRnSmj'][contains(.,'Bem-vindo :)Entre ou cadastre-se')]
${DELIVERY_BUTTON_ALTER_CEP}             //span[@class='BasketAddress-address-change__label'][contains(.,'Alterar')]


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
Acessar página inicial do site Magazine Luiza
    Go To                                           ${HOME_URL}
    Log                                             Acessando a página inicial do site Magazine Luiza

Verificar se o header da pagina é ${HOME_HEADER} 
    Wait Until Page Contains Element                //title[@data-testid='link-0'][contains(.,'${HOME_HEADER}')]
    Log                                             Header da página é ${HOME_HEADER}

Digitar nome "${SEARCH_NAME}" no campo de ${WHERE}
    IF    $WHERE == 'busca'
        Log    Digitar nome "${SEARCH_NAME}" no campo de busca
        Input Text                                  locator=${SEARCH_TEXT}                                                                      text=${SEARCH_NAME}
    ELSE IF    $WHERE == 'filtro'
        Log    Digitar nome "${SEARCH_NAME}" no campo de filtro
        Input Text                                  locator=${SEARCH_FILTER}                                                                    text=${SEARCH_NAME}
    END

Clicar no botao de ${WHERE}
    # IF   $WHERE == 'busca'
        ${SEARCH_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_BUTTON}
        IF    ${SEARCH_IS_VISIBLE}
            Log    Botão de pesquisa encontrado. Clicando no botão.
            Click Element                            ${SEARCH_BUTTON} 
        ELSE
            Log    Botão de pesquisa não encontrado. Pressionando Enter.
            Press Keys                               NONE                                                                                        RETURN
        END
    # ELSE IF   $WHERE == 'filtro'
    #     Press Keys                           NONE                                         RETURN
    # END

Verifica se o filtro de marcas está visível
    Wait Until Page Contains Element                 ${SEARCH_MARCA} 

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


Entrar na página "${PAGE}"
    Click Element                                            //a[@data-testid='link'][contains(.,'${PAGE}')]
    Log     ${PAGE}
    ${CURRENT_URL}    Get Location   
    ${LOWER_STRING}    Convert To Lowercase    ${PAGE}
    ${PAGE_UPDATED}    removing_spaces    ${LOWER_STRING}   
    Should Contain    ${CURRENT_URL}    ${PAGE_UPDATED}      A URL atual não contém a parte esperada: ${PAGE_UPDATED}.

Visualizar o produto ${NAME_PRODUCT}
    Verificar se esta listando o produto "${NAME_PRODUCT}"
    Click Element                                            //h2[@data-testid='product-title'][contains(.,'${NAME_PRODUCT}')]
    Wait Until Page Contains Element                         //h1[@data-testid='heading-product-title'][contains(.,'${NAME_PRODUCT}')]

Adicionar ao carrinho o produto ${NAME_PRODUCT}
    Wait Until Page Contains Element                        //h1[@data-testid='heading-product-title'][contains(.,'${NAME_PRODUCT}')]            timeout=${TIMEOUT} 
    Scroll Element Into View                                ${CART_BUTTON_ADD}       
    Click Element                                           ${CART_BUTTON_ADD}
    Sleep                                                   ${TIMEOUT}
    ${CART_PROTECTION_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible    ${CART_NOT_PROTECTION}     timeout=${TIMEOUT}
    IF   ${CART_PROTECTION_IS_VISIBLE}
        Log    Proteção de compra encontrada. Clicando em "Agora não".
        Wait Until Page Contains Element                        ${CART_NOT_PROTECTION}                                            timeout=${TIMEOUT} 
        Click Element                                           ${CART_BUTTON_NOT_PROTECTION}
    ELSE
        Log    Proteção de compra não encontrada. Indo para a pagina de carrinho.
    END
    Wait Until Page Contains Element                        //p[contains(.,'${NAME_PRODUCT}')]                                                   timeout=${TIMEOUT} 

Verificar se esta listando o produto "${PRODUCT}"
    ${NAME_PRODUCT}    Convert To Lowercase    ${PRODUCT}
    Scroll Element Into View                                //h1[@data-testid='main-title'][contains(.,'${NAME_PRODUCT}')]
    Wait Until Page Contains Element                        //h1[@data-testid='main-title'][contains(.,'${NAME_PRODUCT}')]

Ir ate a pagina de verificacao de compra
    Wait Until Page Contains Element                        //button[@class='BasketContinue-button'][contains(.,'Continuar')]                   timeout=${TIMEOUT}
    Sleep                                                   ${TIMEOUT}
    Click Element                                         //button[@class='BasketContinue-button'][contains(.,'Continuar')]
    # Wait Until Page Contains Element                         //button[@class='AddressList-confirmButton'][contains(.,'Continuar')]                timeout=${TIMEOUT}
    # Click Element                                         //button[@class='AddressList-confirmButton'][contains(.,'Continuar')]
    Wait Until Page Contains Element                         //button[@type='button'][contains(.,'Continuar')]

Verificar opcao de entrega 
    [Arguments]                                           ${BUY_DELIVERY_MESSAGE_OPTION}
    ${SUCESS}    Run Keyword And Return Status    Element Should Be Visible    //div[@class='DeliveryOptionBox'][contains(.,'${BUY_DELIVERY_MESSAGE_OPTION}')]
    IF     ${SUCESS}
        Log                                               Opção de retirada na loja disponível.
    ELSE
        Log                                               Opção de retirada na loja não disponível.
    END

Inserindo CEP no carrinho
    [Arguments]                                           ${CEP}
    Click Element                                         //input[contains(@class,'ZipcodeForm-input')]
    Clear Element Text                                    //input[contains(@class,'ZipcodeForm-input')]
    Input Text                                            //input[contains(@class,'ZipcodeForm-input')]        ${CEP}
    Wait Until Page Contains Element                      //button[@class='buttonWithin'][contains(.,'OK')]                             timeout=${TIMEOUT}
    Click Element                                         //button[@class='buttonWithin'][contains(.,'OK')]

# Home
Dado que o usuário está na página inicial da Magazine Luiza
    Acessar página inicial do site Magazine Luiza
    Verificar se o header da pagina é ${HOME_HEADER} 

Quando ele busca pelo produto "${SEARCH_NAME}"
    Digitar nome "${SEARCH_NAME}" no campo de busca
    Clicar no botao de busca

Retornar para página inicial da Magazine Luiza
    Click Element                                         (//a[@href='https://www.magazineluiza.com.br'])[1]

# Search
Então o produto "${PRODUCT}" deve aparecer nos resultados da pesquisa
    Verificar se esta listando o produto "${PRODUCT}"

E aplica o filtro pela marca
    [Arguments]                                             @{LIST_PRODUCTS}
    Verifica se o filtro de marcas está visível
    FOR    ${LIST_PRODUCTS}            IN                   @{LIST_PRODUCTS}
        Filtrar a marca ${LIST_PRODUCTS}
        Clear Element Text                                  ${SEARCH_FILTER}
        Sleep    1s
    END

Então devem ser exibidos somente produtos das marcas 
    [Arguments]                                             @{LIST_PRODUCTS}
    FOR    ${LIST_PRODUCTS}            IN                   @{LIST_PRODUCTS}
        Page Should Contain                                 ${LIST_PRODUCTS}
        Log                                                 O produto ${LIST_PRODUCTS} foi encontrado na pagina.
    END

Quando ele acessa a página "${PAGE}"
    Entrar na página "${PAGE}" 

# Cart
E adiciona ao carrinho o produto "${NAME_PRODUCT}"
    Visualizar o produto ${NAME_PRODUCT}
    Adicionar ao carrinho o produto ${NAME_PRODUCT}

Então o produto "${NAME_PRODUCT}" deve estar no carrinho
    Wait Until Page Contains Element                        //p[contains(.,'${NAME_PRODUCT}')]                                          timeout=${TIMEOUT} 

Quando ele remove todos os produtos do carrinho
    FOR    ${button}    IN    ${CART_BUTTON_REMOVE_ITEM}
        Click Element    ${button}
        Sleep   2s
        ${CART_EMPTY_STATUS}    Run Keyword And Return Status    Wait Until Page Contains Element    ${CART_VERIFICATION_IS_EMPTY}      timeout=${TIMEOUT} 
        Log   ${CART_EMPTY_STATUS}
        Run Keyword If    ${CART_EMPTY_STATUS}              Exit For Loop
    END

Então o carrinho deve estar vazio
    ${CART_EMPTY_STATUS}    Run Keyword And Return Status    Wait Until Page Contains Element        ${CART_VERIFICATION_IS_EMPTY}       timeout=${TIMEOUT} 

E altera a quantidade de itens para
    [Arguments]                                             ${QUANTITY}
    Page Should Contain Element                             ${CART_QUANTITY_ITEM_PRODUCT}
    Select From List By Value                               ${CART_QUANTITY_ITEM_PRODUCT}                                                ${QUANTITY}
    Sleep                                                   ${TIMEOUT}

Então a quantidade do produto no carrinho deve ser
    [Arguments]                                            ${QUANTITY}
    ${REAL_QUANTITY}    Get Selected List Value            ${CART_QUANTITY_ITEM_PRODUCT}
    Should Be Equal As Numbers                             ${REAL_QUANTITY}                                                              ${QUANTITY}

Quando ele busca e adiciona ao carrinho os produtos  
    [Arguments]                                             @{PRODUCTS}
    FOR    ${PRODUCT}    IN    @{PRODUCTS}
        Quando ele busca pelo produto "${PRODUCT}"
        E adiciona ao carrinho o produto "${PRODUCT}"
        Então o produto "${PRODUCT}" deve estar no carrinho
        Retornar para página inicial da Magazine Luiza
    END

Então devem estar no carrinho todos os produtos pesquisados
    [Arguments]                                             @{PRODUCTS}
    Verificar se esta na pagina carrinho
    FOR    ${PRODUCT}    IN    @{PRODUCTS}
        Wait Until Page Contains Element                    //p[contains(.,'${PRODUCT}')]                                          timeout=${TIMEOUT} 
    END

Verificar se esta na pagina carrinho
    ${DELIVERY_ALTER_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible    //div[@class='Navigation-container'][contains(.,'SacolaIdentificaçãoEntregaPagamento')]     timeout=${TIMEOUT}
    IF    ${DELIVERY_ALTER_IS_VISIBLE}
        Log    Usuário na página de carrinho.
    ELSE
        Log    Usuário não esta na página de carrinho. Direcionando usuario.
        Click Element                                        //div[contains(@class,'sc-bHnlcS iBnAqN')]
    END

    
# Login
Quando ele acessa a página de login
    Wait Until Element Is Enabled                         //a[contains(.,'Entre ou cadastre-se')]                                        timeout=${TIMEOUT}
    Sleep                                                 ${TIMEOUT}
    Click Element                                         //a[contains(.,'Entre ou cadastre-se')]
    Wait Until Page Contains Element                      //div[@class='LoginPage-title'][contains(.,'Identificação')]                   timeout=${TIMEOUT}

E insere credenciais válidas
    [Arguments]                                           &{CREDENTIALS}
    Input Text                                            //input[contains(@autocomplete,'username')]                                    ${CREDENTIALS.email}
    Input Text                                            //input[contains(@type,'password')]                                            ${CREDENTIALS.senha}
    Click Element                                         //button[contains(@id,'login-box-form-continue')]
    Sleep                                                 ${TIMEOUT} 
    Wait Until Page Contains Element                      ${LOGIN_VERIFICATION_SUCESS}                                                   timeout=${TIMEOUT} 

Então o login deve ser realizado com sucesso
    Wait Until Page Contains Element                      ${LOGIN_VERIFICATION_SUCESS}                                                   timeout=${TIMEOUT} 

E o usuário está logado no sistema
    [Arguments]                                           &{CREDENTIALS}
    ${SUCCESS}    Run Keyword And Return Status           Element Should Be Visible                                                      ${LOGIN_VERIFICATION_SUCCESS}
    ${FAIL}       Run Keyword And Return Status           Element Should Be Visible                                                      (//div[contains(.,'Bem-vindo :)Entre ou cadastre-se')])[7]
    ...    #${LOGIN_VERIFICATION_FAIL}

    IF    ${SUCCESS}
        Pass Execution                                    Usuário logado no sistema.
    ELSE IF                                               ${FAIL}
        Log                                               Usuário não logado no sistema.
        Quando ele acessa a página de login
        E insere credenciais válidas                      email=${CREDENTIALS.email}                                                     senha=${CREDENTIALS.senha}
        Então o login deve ser realizado com sucesso
    ELSE
        Fail                                              Falha ao determinar estado do login.
    END


# Delivery
Quando ele abre o pop-up de CEP
    Click Element                                         //div[@class='sc-fqkvVR fbyvQm sc-dOvA-dm jXTXEE'][contains(., 'Ver ofertas para minha região')]
    Wait Until Page Contains Element                      //p[@data-testid='zipcode-title'][contains(.,'Qual a sua localização?')]              timeout=${TIMEOUT}

E insere um CEP válido se necessario                                                  
    [Arguments]                                           ${CEP}
    ${DELIVERY_ALTER_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible    ${DELIVERY_BUTTON_ALTER_CEP}
    Log     ${DELIVERY_ALTER_IS_VISIBLE}

    IF     ${DELIVERY_ALTER_IS_VISIBLE}
        Log     O CEP nao sera alterado pois ja tem um cadastrado.
    ELSE
        Log     Inserindo CEP no carrinho.
        Click Element                                         ${DELIVERY_BUTTON_ALTER_CEP}
        Inserindo CEP no carrinho                         ${CEP}
    END
    Wait Until Element Is Enabled                         //button[@class='BasketContinue-button'][contains(.,'Continuar')]                   timeout=${TIMEOUT}

E insere um CEP inválido
    [Arguments]                                           ${CEP}
    Clear Element Text                                    //input[contains(@name,'zipcode')]
    Input Text                                            //input[contains(@name,'zipcode')]                    ${CEP}
    Wait Until Page Contains Element                      //label[@data-testid='zipcode-label'][contains(.,'CEP não encontrado')]                             timeout=${TIMEOUT}

Então o sistema deve verificar a opção "${DELIVERY_MESSAGE_OPTION}" se disponível
    Ir ate a pagina de verificacao de compra
    Verificar opcao de entrega                           ${DELIVERY_MESSAGE_OPTION}

Então o sistema deve exibir uma mensagem de erro indicando que o CEP é inválido
    Wait Until Page Contains Element                      //label[@data-testid='zipcode-label'][contains(.,'CEP não encontrado')]                             timeout=${TIMEOUT}