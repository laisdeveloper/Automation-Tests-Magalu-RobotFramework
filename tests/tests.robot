*** Settings ***
Documentation       Este arquivo contém os testes para validar passos para compra do site Magazine Luiza
...                 Autor: Lais Coutinho
Resource            ./resources/resource.robot
Test Setup          Abrir navegador
Test Teardown       Fechar navegador

*** Test Cases ***
# Cenário 01: Buscar por Produto
#     Dado que o usuário está na página inicial da Magazine Luiza
#     Quando ele busca pelo produto "Notebook"
#     Então o produto "Notebook" deve aparecer nos resultados da pesquisa

Cenário 02: Filtrar Produtos pela Marca
    Dado que o usuário está na página inicial da Magazine Luiza
    Quando ele busca pelo produto "TV"
    E aplica os filtros pelas marcas     Samsung    LG    PHILIPS
    # Então devem ser exibidos somente produtos das marcas    Samsung    LG    PHILIPS

# Cenário 03: Ver Ofertas de uma Categoria
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Offers.Quando ele acessa a página "Ofertas do Dia"
#     Offers.E aplica o filtro pela categoria "Móveis"
#     Offers.Então apenas produtos da categoria "Móveis" devem ser exibidos

# Cenário 04: Adicionar Múltiplos Produtos ao Carrinho
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Search.Pesquisa.Quando ele pesquisa pelos produtos desejados
#     Cart.E adiciona os produtos ao carrinho
#     Cart.Então todos os produtos pesquisados devem estar no carrinho

# Cenário 05: Adicionar Único Produto ao Carrinho
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Search.Quando ele busca pelo produto "Notebook"
#     Cart.E adiciona o produto ao carrinho
#     Cart.Então o produto "Notebook" deve estar no carrinho

# Cenário 06: Esvaziar Carrinho
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Quando ele adiciona produtos ao carrinho
#     Cart.E acessa o carrinho
#     Cart.Carrinho.E remove todos os produtos
#     Cart.Então o carrinho deve estar vazio

# Cenário 07: Alterar Quantidade de Itens no Carrinho
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Search.Quando ele busca pelo produto "Notebook"
#     Cart.E adiciona o produto ao carrinho
#     Cart.E altera a quantidade para 2 itens
#     Cart.Então a quantidade do produto no carrinho deve ser 2

# Cenário 08: Fazer Login com Credenciais Válidas
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Login.uando ele acessa a página de login
#     Login.E insere credenciais válidas
#     Login.Então o login deve ser realizado com sucesso

# Cenário 09: Tratar CEP Inválido
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Buy.Quando ele abre o pop-up de CEP
#     Buy.E insere um CEP inválido
#     Buy.Então o sistema deve exibir uma mensagem de erro indicando que o CEP é inválido

# Cenário 10: Verificar Opção de Retirada na Loja
#     Home.Dado que o usuário está na página inicial da Magazine Luiza
#     Search.Quando ele busca pelo produto "Notebook"
#     Cart.E adiciona o produto ao carrinho
#     Buy.E insere um CEP válido
#     Buy.Então o sistema deve exibir a opção "Retire na Loja" se disponível
