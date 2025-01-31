*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados à entrega do site Magazine Luiza.

Resource                                                  ../../resource.robot
Resource                                                  ../Cart/Cart.robot
Resource                                                  ../Search/Search.robot


*** Variables ***
${DELIVERY_BUTTON_ALTER_CEP}                              //span[@class='BasketAddress-address-change__label'][contains(.,'Alterar')]
${DELIVERY_BUTTON_ACESS_CEP}                              //div[@class='sc-fqkvVR fbyvQm sc-dOvA-dm jXTXEE'][contains(., 'Ver ofertas para minha região')]
${DELIVERY_MESSAGE_CONFIRM_POPUP}                         //p[@data-testid='zipcode-title'][contains(.,'Qual a sua localização?')]
${DELIVERY_INPUT_CEP_CART_NAME}                           //input[contains(@name,'zipcode')]
${DELIVERY_INPUT_CEP_CART_CLASS}                          //input[contains(@class,'ZipcodeForm-input')]
${DELIVERY_MESSAGE_NOT_FOUND}                             //label[@data-testid='zipcode-label'][contains(.,'CEP não encontrado')]
${DELIVERY_BUTTON_CONTINUE_CART}                          //button[@class='BasketContinue-button'][contains(.,'Continuar')]
${DELIVERY_BUTTON_CONFIRM_CEP_CART}                       //button[@class='buttonWithin'][contains(.,'OK')]

*** Keywords ***
Quando ele abre o pop-up de CEP
    Log                                                   Abrindo pop-up de CEP
    Click Element                                         ${DELIVERY_BUTTON_ACESS_CEP}
    Wait Until Page Contains Element                      ${DELIVERY_MESSAGE_CONFIRM_POPUP}                                                                   timeout=${TIMEOUT}

E insere um CEP válido se necessario                                                  
    [Arguments]                                           ${CEP}
    Log                                                   Verificando se o CEP já está cadastrado.
    ${DELIVERY_ALTER_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible                                                                ${DELIVERY_BUTTON_ALTER_CEP}
    Log                                                   ${DELIVERY_ALTER_IS_VISIBLE}

    IF                                                    ${DELIVERY_ALTER_IS_VISIBLE}
        Log                                               O CEP nao sera alterado pois ja tem um cadastrado.
    ELSE
        Log                                               Inserindo CEP no carrinho.
        Click Element                                     ${DELIVERY_BUTTON_ALTER_CEP}
        Inserindo CEP no carrinho                         ${CEP}
    END
    Log                                                   Esperando conclusão do processo.
    Wait Until Element Is Enabled                         ${DELIVERY_BUTTON_CONTINUE_CART}                                                                    timeout=${TIMEOUT}

E insere um CEP inválido
    [Arguments]                                           ${CEP}
    Log                                                   Limpando campo de CEP.
    Clear Element Text                                    ${DELIVERY_INPUT_CEP_CART_NAME} 
    Log                                                   Inserindo CEP inválido.
    Input Text                                            ${DELIVERY_INPUT_CEP_CART_NAME}                                                                     ${CEP}
    Log                                                   Verificando se a messagem de erro é exibida.
    Wait Until Page Contains Element                      ${DELIVERY_MESSAGE_NOT_FOUND}                                                                       timeout=${TIMEOUT}

Então o sistema deve verificar a opção "${DELIVERY_MESSAGE_OPTION}" se disponível
    Log                                                   Verificando opção de entrega. Exemplo: Retire na loja.
    Ir ate a pagina de verificacao de compra
    Verificar opcao de entrega                           ${DELIVERY_MESSAGE_OPTION}

Então o sistema deve exibir uma mensagem de erro indicando que o CEP é inválido
    Log                                                   Verificando se a messagem de erro é exibida.
    Wait Until Page Contains Element                      ${DELIVERY_MESSAGE_NOT_FOUND}                                                                       timeout=${TIMEOUT}



# Keywords Complementares
Verificar opcao de entrega 
    [Arguments]                                           ${BUY_DELIVERY_MESSAGE_OPTION}
    ${SUCESS}    Run Keyword And Return Status            Element Should Be Visible                    //div[@class='DeliveryOptionBox'][contains(.,'${BUY_DELIVERY_MESSAGE_OPTION}')]
    IF                                                    ${SUCESS}
        Log                                               Opção de retirada na loja disponível.
    ELSE
        Log                                               Opção de retirada na loja não disponível.
    END

Ir ate a pagina de verificacao de compra
    Log                                                   Esperando a pagina de verificacao de compra carregar.
    Wait Until Page Contains Element                      ${DELIVERY_BUTTON_CONTINUE_CART}                                                                    timeout=${TIMEOUT}
    Sleep                                                 ${TIMEOUT_SLEEP}
    Log                                                   Indo para a pagina de verificacao de compra.
    Click Element                                         ${DELIVERY_BUTTON_CONTINUE_CART}
    Wait Until Page Contains Element                      //button[@type='button'][contains(.,'Continuar')]                                                   timeout=${TIMEOUT}

Inserindo CEP no carrinho
    [Arguments]                                           ${CEP}
    Log                                                   Inserindo CEP no carrinho.
    Click Element                                         ${DELIVERY_INPUT_CEP_CART_CLASS} 
    Clear Element Text                                    ${DELIVERY_INPUT_CEP_CART_CLASS} 
    Input Text                                            ${DELIVERY_INPUT_CEP_CART_CLASS}                                                                     ${CEP}
    Log                                                   Espera o processo de inserção do CEP.
    Wait Until Page Contains Element                      ${DELIVERY_BUTTON_CONFIRM_CEP_CART}                                                                  timeout=${TIMEOUT}
    Log                                                   Confirmando CEP.
    Click Element                                         ${DELIVERY_BUTTON_CONFIRM_CEP_CART}


