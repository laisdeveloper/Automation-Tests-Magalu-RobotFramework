*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados ao carrinho de compras do site Magazine Luiza.

Resource                                                            ../../resource.robot
Resource                                                            ../Search/Search.robot

*** Variables ***
${CART_BUTTON_ADD}                                                  (//button[@color='secondary'][contains(.,'Adicionar à Sacola')])[1]
${CART_NOT_PROTECTION}                                              //strong[contains(.,'"Incluir proteção"')]
${CART_BUTTON_NOT_PROTECTION}                                       //button[@color='secondary'][contains(.,'Agora não')]
${CART_BUTTON_REMOVE_ITEM}                                          //span[@class='BasketItem-delete-label'][contains(.,'Excluir')]
${CART_VERIFICATION_IS_EMPTY}                                       //div[@class='EmptyBasket-title'][contains(.,'Sua sacola está vazia')]
${CART_VERIFICATION_IS_CART}                                        //div[@class='Navigation-container'][contains(.,'SacolaIdentificaçãoEntregaPagamento')]
${CART_QUANTITY_ITEM_PRODUCT}                                       //select[contains(@class,'BasketItemProduct-quantity-dropdown')]
${CART_GO_TO}                                                       //div[contains(@class,'sc-bHnlcS iBnAqN')]

*** Keywords ***
Quando ele remove todos os produtos do carrinho
    FOR    ${button}    IN                                          ${CART_BUTTON_REMOVE_ITEM}
        Log                                                         Clicando no botao de remover.
        Click Element                                               ${button}
        Sleep                                                       ${TIMEOUT_SLEEP}
        Log                                                         Verifica se o carrinho esta vazio.
        ${CART_EMPTY_STATUS}    Run Keyword And Return Status       Wait Until Page Contains Element        ${CART_VERIFICATION_IS_EMPTY}              timeout=${TIMEOUT} 
        Log                                                         ${CART_EMPTY_STATUS}
        Log                                                         Se o carrinho estiver vazio, sair do loop.
        Log                                                         Se o carrinho não estiver vazio, continuar o loop.
        Run Keyword If                                              ${CART_EMPTY_STATUS}                    Exit For Loop
    END


Quando ele busca e adiciona ao carrinho os produtos  
    [Arguments]                                                     @{PRODUCTS}
    FOR    ${PRODUCT}    IN                                         @{PRODUCTS}
        Log                                                         Loop de busca e adição de produtos ao carrinho.
        Quando ele busca pelo produto "${PRODUCT}"
        E adiciona ao carrinho o produto "${PRODUCT}"
        Então o produto "${PRODUCT}" deve estar no carrinho
        Retornar para página inicial da Magazine Luiza
    END
    

E adiciona ao carrinho o produto "${NAME_PRODUCT}"
    Visualizar o produto ${NAME_PRODUCT}
    Adicionar ao carrinho o produto ${NAME_PRODUCT}


E altera a quantidade de itens para
    [Arguments]                                                    ${QUANTITY}
    Page Should Contain Element                                    ${CART_QUANTITY_ITEM_PRODUCT}
    Log                                                            Selecionando o select para poder escolher a quantidade.
    Select From List By Value                                      ${CART_QUANTITY_ITEM_PRODUCT}                                                       ${QUANTITY}
    Sleep                                                          ${TIMEOUT_SLEEP}


Então o produto "${NAME_PRODUCT}" deve estar no carrinho
    Log                                                         Verifica se o produto "${NAME_PRODUCT}" esta no carrinho.
    Wait Until Page Contains Element                               //p[contains(.,'${NAME_PRODUCT}')]                                                  timeout=${TIMEOUT} 


Então o carrinho deve estar vazio
    Log                                                         Verifica se o carrinho esta vazio.
    ${CART_EMPTY_STATUS}    Run Keyword And Return Status          Wait Until Page Contains Element        ${CART_VERIFICATION_IS_EMPTY}               timeout=${TIMEOUT} 


Então a quantidade do produto no carrinho deve ser
    [Arguments]                                                    ${QUANTITY}
    Log                                                            Verifica se a quantidade do produto no carrinho é igual a "${QUANTITY}".
    ${REAL_QUANTITY}    Get Selected List Value                    ${CART_QUANTITY_ITEM_PRODUCT}
    Should Be Equal As Numbers                                     ${REAL_QUANTITY}                                                                     ${QUANTITY}


Então devem estar no carrinho todos os produtos pesquisados
    [Arguments]                                                    @{PRODUCTS}
    Verificar se esta na pagina carrinho
    FOR    ${PRODUCT}    IN                                        @{PRODUCTS}
        Log                                                        Verificando se o produto "${PRODUCT}" esta no carrinho.
        Wait Until Page Contains Element                           //p[contains(.,'${PRODUCT}')]                                                        timeout=${TIMEOUT} 
    END


# Keywords Complementares
Verificar se esta na pagina carrinho
    ${DELIVERY_ALTER_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible             ${CART_VERIFICATION_IS_CART}                 timeout=${TIMEOUT}
    Log                                                            Verifica se o usuário esta na página de carrinho.
    Log                                                            Se true, nao faz nada.
    Log                                                            Se false, direciona o ususario a página de carrinho.
    IF    ${DELIVERY_ALTER_IS_VISIBLE}
        Log                                                        Usuário na página de carrinho.
    ELSE
        Log                                                        Usuário não esta na página de carrinho. Direcionando usuario.
        Click Element                                              ${CART_GO_TO}
    END

Visualizar o produto ${NAME_PRODUCT}
    Verificar se esta listando o produto "${NAME_PRODUCT}"
    Log                                                            Clica no elemento que contém o nome do produto "${NAME_PRODUCT}".
    Click Element                                                  //h2[@data-testid='product-title'][contains(.,'${NAME_PRODUCT}')]
    Wait Until Page Contains Element                               //h1[@data-testid='heading-product-title'][contains(.,'${NAME_PRODUCT}')]            timeout=${TIMEOUT}

Adicionar ao carrinho o produto ${NAME_PRODUCT}
    Log                                                            Espera ate que a pagina contenha o nome do produto "${NAME_PRODUCT}".
    Wait Until Page Contains Element                               //h1[@data-testid='heading-product-title'][contains(.,'${NAME_PRODUCT}')]            timeout=${TIMEOUT} 
    Wait Until Page Contains                                       ${NAME_PRODUCT}                                                                      timeout=${TIMEOUT}
    Log                                                            Direciona ate onde tem o botao de "Adicionar ao carrinho".
    Scroll Element Into View                                       ${CART_BUTTON_ADD}       
    Click Element                                                  ${CART_BUTTON_ADD}
    Sleep                                                          ${TIMEOUT_SLEEP}

    Log                                                            Se o produto tiver que escolher a proteção de compra, clicar em "Agora não".
    Log                                                            Se nao, ir para a pagina de carrinho.
    ${CART_PROTECTION_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible            ${CART_NOT_PROTECTION}                       timeout=${TIMEOUT}
    IF                                                             ${CART_PROTECTION_IS_VISIBLE}
        Log                                                        Proteção de compra encontrada. Clicando em "Agora não".
        Wait Until Page Contains Element                           ${CART_NOT_PROTECTION}                                                               timeout=${TIMEOUT} 
        Click Element                                              ${CART_BUTTON_NOT_PROTECTION}
    ELSE
        Log                                                        Proteção de compra não encontrada. Indo para a pagina de carrinho.
    END
    Wait Until Page Contains Element                               //p[contains(.,'${NAME_PRODUCT}')]                                                   timeout=${TIMEOUT} 