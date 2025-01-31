*** Settings ***
Documentation       Este arquivo contém os testes para validar os passos principais de navegação, busca, filtragem, 
...                 manipulação do carrinho, login e tratamento de erros no site Magazine Luiza.
...                 Ele cobre cenários críticos para garantir uma experiência fluida de compra para o usuário.
...                    Autor: Lais Coutinho

Resource            ../resources/resource.robot
Resource            ../resources/variables/env_variables.robot

Test Setup          Abrir navegador
Test Teardown       Fechar navegador

Library    SeleniumLibrary
Library    OperatingSystem

*** Test Cases ***
Cenário 01: Fazer Login com Credenciais Válidas
    [Documentation]  Este cenário valida o login no site com credenciais válidas. 
    ...    Ele garante que o sistema permita o acesso somente a usuários autenticados corretamente.
    [Tags]            sc01    Login    LoginWithValidCredentials
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele acessa a página de login
    E insere credenciais válidas                                                    email=${EMAIL}                      senha=${PASSWORD}
    Então o login deve ser realizado com sucesso

Cenário 02: Tratar CEP Inválido
    [Documentation]  Este cenário valida o comportamento do sistema ao receber um CEP inválido. 
    ...    Ele garante que o sistema exiba mensagens claras e não prossiga com CEPs incorretos.
    [Tags]            sc02    Delivery    InvalidCEP
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele abre o pop-up de CEP
    E insere um CEP inválido                                                        00000000
    Então o sistema deve exibir uma mensagem de erro indicando que o CEP é inválido

Cenário 03: Verificar Opção de Retirada na Loja
    [Documentation]  Este cenário valida se o sistema verifica corretamente a opção de retirada na loja, qquando um CEP válido é fornecido.
    [Tags]            sc03    Cart    Delivery    StorePickup
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E o usuário está logado no sistema                                              email=${EMAIL}                       senha=${PASSWORD}
    E adiciona ao carrinho o produto "Notebook"
    E insere um CEP válido se necessario                                            62320041
    Então o sistema deve verificar a opção "Retire na loja" se disponível

Cenário 04: Buscar por Produto
    [Documentation]  Este cenário valida a funcionalidade de busca do site, verificando se um produto pesquisado 
    ...    aparece corretamente nos resultados exibidos. É essencial para assegurar a precisão e usabilidade da busca.
    [Tags]            sc04    Search    SearchProduct
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    Então o produto "Notebook" deve aparecer nos resultados da pesquisa

Cenário 05: Filtrar Produtos pela Marca
    [Documentation]  Este cenário verifica a capacidade do sistema de filtrar produtos por marca específica. 
    ...     O objetivo é garantir que o filtro funcione corretamente e retorne apenas produtos relevantes ao critério.
    [Tags]            sc05    Search    Filter    FilterByBrand
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "TV"
    E aplica o filtro pela marca                                                     Samsung            LG                Philips
    Então devem ser exibidos somente produtos das marcas                             Samsung            LG                Philips

Cenário 06: Ver Ofertas de uma Marca
    [Documentation]  Este cenário valida se o usuário consegue visualizar corretamente as ofertas disponíveis para uma marca específica.
    [Tags]            sc06    Search    ViewBrandOffers
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele acessa a página "Ofertas do Dia"
    E aplica o filtro pela marca                                                     Adidas
    Então devem ser exibidos somente produtos das marcas                             Adidas

Cenário 07: Adicionar Múltiplos Produtos ao Carrinho
    [Documentation]  Este cenário avalia a funcionalidade de adicionar vários produtos ao carrinho de compras.
    ...    Ele garante que os produtos selecionados sejam incluídos corretamente e exibidos no carrinho.
    [Tags]            sc07    Cart    AddMultipleProductsToCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca e adiciona ao carrinho os produtos                             Brinquedo            Notebook          Celular   
    Então devem estar no carrinho todos os produtos pesquisados                     Brinquedo            Notebook          Celular   

Cenário 08: Adicionar Único Produto ao Carrinho
    [Documentation]  ste cenário verifica a funcionalidade de adicionar um único produto ao carrinho de compras, 
    ...    garantindo que ele seja corretamente incluído e exibido no carrinho.
    [Tags]            sc08    Cart    AddProductToCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E adiciona ao carrinho o produto "Notebook"
    Então o produto "Notebook" deve estar no carrinho

Cenário 09: Esvaziar Carrinho
    [Documentation]  Este cenário valida a funcionalidade de remoção de todos os itens do carrinho de compras.
    [Tags]            sc09    Cart    EmptyCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E adiciona ao carrinho o produto "Notebook"
    Então o produto "Notebook" deve estar no carrinho
    Quando ele remove todos os produtos do carrinho
    Então o carrinho deve estar vazio

Cenário 10: Alterar Quantidade de Itens no Carrinho
    [Documentation]  Este cenário verifica a funcionalidade de alterar a quantidade de itens no carrinho. 
    ...    Ele garante que o usuário consiga ajustar a quantidade de um produto selecionado conforme necessário.
    [Tags]            sc10    Cart    Quantity    ChangeQuantityInCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E adiciona ao carrinho o produto "Notebook"
    E altera a quantidade de itens para                                             2
    Então a quantidade do produto no carrinho deve ser                              2