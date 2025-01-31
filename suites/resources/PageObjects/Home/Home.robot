*** Settings ***
Documentation       Este arquivo contém os Page Objects relacionados à página inicial do site Magazine Luiza.

Resource                                 ../../resource.robot


*** Variables ***
${HOME_URL}                                                https://www.magazineluiza.com.br
${HOME_HEADER}                                             Magazine Luiza | Pra você é Magalu!


*** Keywords ***
Dado que o usuário está na página inicial da Magazine Luiza
    Acessar página inicial do site Magazine Luiza
    Verificar se o header da pagina é ${HOME_HEADER} 

Quando ele busca pelo produto "${SEARCH_NAME}"
    Digitar nome "${SEARCH_NAME}" no campo de busca
    Clicar no botao de busca

Retornar para página inicial da Magazine Luiza
    Click Element                                         (//a[@href='https://www.magazineluiza.com.br'])[1]



# Keywords Complementares/Granularizadas
Acessar página inicial do site Magazine Luiza
    Go To                                                  ${HOME_URL}
    Log                                                    Acessando a página inicial do site Magazine Luiza

Verificar se o header da pagina é ${HOME_HEADER} 
    Wait Until Page Contains Element                       //title[@data-testid='link-0'][contains(.,'${HOME_HEADER}')]
    Log                                                    Header da página é ${HOME_HEADER}

Clicar no botao de ${WHERE}
    # IF   $WHERE == 'busca'
        ${SEARCH_IS_VISIBLE}    Run Keyword And Return Status    Element Should Be Visible    ${SEARCH_BUTTON}
        IF    ${SEARCH_IS_VISIBLE}
            Log                                            Botão de pesquisa encontrado. Clicando no botão.
            Click Element                                  ${SEARCH_BUTTON} 
        ELSE
            Log                                            Botão de pesquisa não encontrado. Pressionando Enter.
            Press Keys                                     NONE                                                                                        RETURN
        END
    # ELSE IF   $WHERE == 'filtro'
    #     Press Keys                           NONE                                         RETURN
    # END