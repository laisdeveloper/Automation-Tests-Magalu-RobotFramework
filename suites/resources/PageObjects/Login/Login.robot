*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados ao login do site Magazine Luiza.

Resource                                 ../../resource.robot


*** Variables ***
${LOGIN_VERIFICATION_SUCESS}             //div[@class='sc-ggqIjW jRnSmj'][contains(.,'Olá, ')]
${LOGIN_VERIFICATION_FAIL}               //div[@class='sc-ggqIjW jRnSmj'][contains(.,'Bem-vindo :)Entre ou cadastre-se')]


*** Keywords ***
Quando ele acessa a página de login
    Log                                                   Esperando página de login carregar.
    Wait Until Element Is Enabled                         //a[contains(.,'Entre ou cadastre-se')]                                        timeout=${TIMEOUT}
    Sleep                                                 ${TIMEOUT_SLEEP}
    Log                                                   Direcionando para página de login.
    Click Element                                         //a[contains(.,'Entre ou cadastre-se')]
    Wait Until Page Contains Element                      //div[@class='LoginPage-title'][contains(.,'Identificação')]                   timeout=${TIMEOUT}


E insere credenciais válidas
    [Arguments]                                           &{CREDENTIALS}
    Log                                                   Inserindo as credenciais.
    Input Text                                            //input[contains(@autocomplete,'username')]                                    ${CREDENTIALS.email}
    Input Text                                            //input[contains(@type,'password')]                                            ${CREDENTIALS.senha}
    Log                                                   Clicando no botão de login, para verificar o login
    Click Element                                         //button[contains(@id,'login-box-form-continue')]
    Sleep                                                 ${TIMEOUT_SLEEP}
    Wait Until Page Contains Element                      ${LOGIN_VERIFICATION_SUCESS}                                                   timeout=${TIMEOUT} 


E o usuário está logado no sistema
    [Arguments]                                           &{CREDENTIALS}
    Log                                                   Verificando se o usuário está logado.
    ${SUCCESS}    Run Keyword And Return Status           Element Should Be Visible                                                      ${LOGIN_VERIFICATION_SUCCESS}
    ${FAIL}       Run Keyword And Return Status           Element Should Be Visible                                                      (//div[contains(.,'Bem-vindo :)Entre ou cadastre-se')])[7]
    ...    #${LOGIN_VERIFICATION_FAIL}

    Log                                                   Se o usuário está logado, passa a execução.
    Log                                                   Se o usuário não está logado, realiza o login.
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


Então o login deve ser realizado com sucesso
    Log                                               Verificando se o login foi realizado com sucesso.
    Wait Until Page Contains Element                      ${LOGIN_VERIFICATION_SUCESS}                                                   timeout=${TIMEOUT} 


# Keywords Complementares