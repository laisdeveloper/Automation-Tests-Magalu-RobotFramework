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

Retornar para página inicial da Magazine Luiza
    Log                                               Retornando para a página inicial do site Magazine Luiza, clicando no logo
    Click Element                                         (//a[@href='${HOME_URL}'])[1]


# Keywords Complementares/Granularizadas
Acessar página inicial do site Magazine Luiza
    Go To                                                  ${HOME_URL}
    Log                                                    Acessando a página inicial do site Magazine Luiza

Verificar se o header da pagina é ${HOME_HEADER} 
    Wait Until Page Contains Element                       //title[@data-testid='link-0'][contains(.,'${HOME_HEADER}')]
    Log                                                    Header da página é ${HOME_HEADER}