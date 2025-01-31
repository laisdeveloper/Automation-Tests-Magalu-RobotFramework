*** Settings ***
Documentation       Este arquivo contém os testes para validar os passos principais de navegação, busca, filtragem, 
...                 manipulação do carrinho, login e tratamento de erros no site Magazine Luiza.
...                 Ele cobre cenários críticos para garantir uma experiência fluida de compra para o usuário.
...                    Autor: Lais Coutinho

Resource            ../resources/resource.robot
Resource            ../resources/variables/env_variables.robot

Test Setup          Abrir navegador
Test Teardown       Fechar navegador

*** Test Cases ***
TC001 - Fazer Login com Credenciais Válidas
    [Documentation]  Permitir o acesso do usuário com email e senha válidos.
    [Tags]            sc01    Login    LoginWithValidCredentials
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele acessa a página de login
    E insere credenciais válidas                                                    email=${EMAIL}                      senha=${PASSWORD}
    Então o login deve ser realizado com sucesso

TC002 - Tratar CEP Inválido
    [Documentation]  Apresentar mensagem de erro ao inserir um CEP inválido.
    [Tags]            sc02    Delivery    InvalidCEP
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele abre o pop-up de CEP
    E insere um CEP inválido                                                        00000000
    Então o sistema deve exibir uma mensagem de erro indicando que o CEP é inválido

TC003 - Verificar Opção de Retirada na Loja
    [Documentation]  Checar se um produto tem a opção de ser retirado em loja física.
    [Tags]            sc03    Cart    Delivery    StorePickup
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E o usuário está logado no sistema                                              email=${EMAIL}                       senha=${PASSWORD}
    E adiciona ao carrinho o produto "Notebook"
    E insere um CEP válido se necessario                                            62320041
    Então o sistema deve verificar a opção "Retire na loja" se disponível

TC004 - Buscar por Produto
    [Documentation]  Realizar a busca de um produto pelo nome.
    [Tags]            sc04    Search    SearchProduct
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    Então o produto "Notebook" deve aparecer nos resultados da pesquisa

TC005 - Filtrar Produtos pela Marca
    [Documentation]  Aplicar filtros de marca em uma busca por produtos.
    [Tags]            sc05    Search    Filter    FilterByBrand
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "TV"
    E aplica o filtro pela marca                                                     Samsung            LG                Philips
    Então devem ser exibidos somente produtos das marcas                             Samsung            LG                Philips

TC006 - Ver Ofertas de uma Marca
    [Documentation]  Exibir produtos em promoção de uma categoria específica.
    [Tags]            sc06    Search    ViewBrandOffers
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele acessa a página "Ofertas do Dia"
    E aplica o filtro pela marca                                                     Adidas
    Então devem ser exibidos somente produtos das marcas                             Adidas

TC007 - Adicionar Múltiplos Produtos ao Carrinho
    [Documentation]  Adicionar vários produtos ao carrinho.
    [Tags]            sc07    Cart    AddMultipleProductsToCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca e adiciona ao carrinho os produtos                             Brinquedo            Notebook          Celular   
    Então devem estar no carrinho todos os produtos pesquisados                     Brinquedo            Notebook          Celular   

TC008 - Adicionar Único Produto ao Carrinho
    [Documentation]  Adicionar um produto específico ao carrinho.
    [Tags]            sc08    Cart    AddProductToCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E adiciona ao carrinho o produto "Notebook"
    Então o produto "Notebook" deve estar no carrinho

TC009 - Esvaziar Carrinho
    [Documentation]  Remover todos os produtos do carrinho.
    [Tags]            sc09    Cart    EmptyCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E adiciona ao carrinho o produto "Notebook"
    Então o produto "Notebook" deve estar no carrinho
    Quando ele remove todos os produtos do carrinho
    Então o carrinho deve estar vazio

TC010 - Alterar Quantidade de Itens no Carrinho
    [Documentation]  Alterar o número de unidades de um produto no carrinho.
    [Tags]            sc10    Cart    Quantity    ChangeQuantityInCart
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "Notebook"
    E adiciona ao carrinho o produto "Notebook"
    E altera a quantidade de itens para                                             2
    Então a quantidade do produto no carrinho deve ser                              2