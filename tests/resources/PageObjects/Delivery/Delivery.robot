*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados à entrega do site Magazine Luiza.

Resource                ../Cart/Cart.robot
Resource                ../Search/Search.robot


*** Variables ***
${DELIVERY_BUTTON_ALTER_CEP}             //span[@class='BasketAddress-address-change__label'][contains(.,'Alterar')]


*** Keywords ***
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



# Keywords Complementares
Verificar opcao de entrega 
    [Arguments]                                           ${BUY_DELIVERY_MESSAGE_OPTION}
    ${SUCESS}    Run Keyword And Return Status    Element Should Be Visible    //div[@class='DeliveryOptionBox'][contains(.,'${BUY_DELIVERY_MESSAGE_OPTION}')]
    IF     ${SUCESS}
        Log                                               Opção de retirada na loja disponível.
    ELSE
        Log                                               Opção de retirada na loja não disponível.
    END

Ir ate a pagina de verificacao de compra
    Wait Until Page Contains Element                        //button[@class='BasketContinue-button'][contains(.,'Continuar')]                   timeout=${TIMEOUT}
    Sleep                                                   ${TIMEOUT_SLEEP}
    Click Element                                         //button[@class='BasketContinue-button'][contains(.,'Continuar')]
    # Wait Until Page Contains Element                         //button[@class='AddressList-confirmButton'][contains(.,'Continuar')]                timeout=${TIMEOUT}
    # Click Element                                         //button[@class='AddressList-confirmButton'][contains(.,'Continuar')]
    Wait Until Page Contains Element                         //button[@type='button'][contains(.,'Continuar')]        timeout=${TIMEOUT}

Inserindo CEP no carrinho
    [Arguments]                                           ${CEP}
    Click Element                                         //input[contains(@class,'ZipcodeForm-input')]
    Clear Element Text                                    //input[contains(@class,'ZipcodeForm-input')]
    Input Text                                            //input[contains(@class,'ZipcodeForm-input')]        ${CEP}
    Wait Until Page Contains Element                      //button[@class='buttonWithin'][contains(.,'OK')]                             timeout=${TIMEOUT}
    Click Element                                         //button[@class='buttonWithin'][contains(.,'OK')]


