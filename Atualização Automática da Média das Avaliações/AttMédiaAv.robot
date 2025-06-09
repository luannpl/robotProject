*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String

*** Variables ***
${URL}                  http://localhost:3000/auth/signin
${BROWSER}              chrome
${EMAIL}                teste3@gmail.com
${SENHA}                teste123
${TIMEOUT}              15s
${TITULO_AVALIACAO}     Avaliação Robot Framework
${DESCRICAO_AVALIACAO}  Descrição Automatizada com Robot Framework

&{ELEMENTOS}
...    inp_email=//input[contains(@placeholder, 'seu@email.com')]
...    inp_senha=//input[@id='password']
...    btn_entrar=//button[contains(.,'Entrar')]
...    link_filme=//h3[contains(text(),'Lilo & Stitch')]/ancestor::a
...    btn_escrever_avaliacao=//button[contains(.,'Escrever avaliação')]
...    inp_titulo_avaliacao=//input[@id='title']
...    editor_descricao=//div[contains(@class,'ProseMirror')]
...    btn_estrela_3=//button[@aria-label='3 estrelas' and contains(@class,'cursor-pointer')]
...    btn_publicar=//button[contains(@class,'bg-rose-500') and contains(.,'Publicar')]

*** Keywords ***
aguardar elemento visivel
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}

aguardar elemento clicavel
    [Arguments]    ${locator}
    Wait Until Element Is Enabled    ${locator}    timeout=${TIMEOUT}

realizar clique
    [Arguments]    ${locator}
    aguardar elemento visivel       ${locator}
    Click Element                   ${locator}
    Sleep                           0.5s
    Capture Page Screenshot

fazer login
    Log To Console    Iniciando login...
    aguardar elemento visivel       ${ELEMENTOS.inp_email}
    Input Text                      ${ELEMENTOS.inp_email}      ${EMAIL}
    Input Text                      ${ELEMENTOS.inp_senha}      ${SENHA}
    Capture Page Screenshot
    Click Element                   ${ELEMENTOS.btn_entrar}
    Log To Console    Login realizado, aguardando carregar...
    Sleep                           3s
    Capture Page Screenshot

acessar_pagina_filme
    Log To Console    Acessando página do filme...
    aguardar elemento clicavel      ${ELEMENTOS.link_filme}
    Click Element                   ${ELEMENTOS.link_filme}
    Sleep                           3s
    Capture Page Screenshot
    Log To Console    Página do filme carregada

escrever_avaliacao
    Log To Console    Clicando no botão 'Escrever avaliação'...
    aguardar elemento clicavel      ${ELEMENTOS.btn_escrever_avaliacao}
    realizar clique                 ${ELEMENTOS.btn_escrever_avaliacao}
    Sleep                           2s
    Capture Page Screenshot
    Log To Console    Formulário de avaliação aberto

preencher_descricao_avaliacao
    [Arguments]    ${descricao}=${DESCRICAO_AVALIACAO}
    Log To Console    Preenchendo descrição da avaliação...
    
    aguardar elemento visivel       ${ELEMENTOS.editor_descricao}
    Click Element                   ${ELEMENTOS.editor_descricao}
    Press Keys                      ${ELEMENTOS.editor_descricao}    ${descricao}
    
    ${conteudo}=    Get Element Attribute    ${ELEMENTOS.editor_descricao}    innerText
    Should Contain    ${conteudo}    ${descricao}
    
    Capture Page Screenshot
    Log To Console    Descrição preenchida: ${descricao}

selecionar_nota_avaliacao
    Log To Console    Selecionando 3 estrelas para avaliação...
    
    # Localiza o botão específico de 3 estrelas
    aguardar elemento visivel    ${ELEMENTOS.btn_estrela_3}
    
    # Clica no botão de 3 estrelas
    Mouse Over    ${ELEMENTOS.btn_estrela_3}
    Sleep         0.3s
    Click Element ${ELEMENTOS.btn_estrela_3}
    
    # Verifica se foi selecionada (muda para fill-yellow-400)
    ${locator_svg_selecionado}    Set Variable    ${ELEMENTOS.btn_estrela_3}//*[local-name()='svg' and contains(@class,'fill-yellow-400')]
    Wait Until Element Is Visible    ${locator_svg_selecionado}    timeout=${TIMEOUT}
    
    Capture Page Screenshot
    Log To Console    3 estrelas selecionadas com sucesso

preencher_formulario_avaliacao
    [Arguments]    ${titulo}=${TITULO_AVALIACAO}    ${descricao}=${DESCRICAO_AVALIACAO}
    Log To Console    Preenchendo formulário completo de avaliação...
    
    # Preencher título
    aguardar elemento visivel       ${ELEMENTOS.inp_titulo_avaliacao}
    Input Text                      ${ELEMENTOS.inp_titulo_avaliacao}    ${titulo}
    
    # Preencher descrição
    preencher_descricao_avaliacao    ${descricao}
    
    # Selecionar nota (fixa em 3 estrelas conforme o elemento fornecido)
    selecionar_nota_avaliacao
    
    Capture Page Screenshot
    Log To Console    Formulário preenchido: Título="${titulo}", Nota=3 estrelas

submeter_avaliacao
    Log To Console    Submetendo avaliação...
    aguardar elemento clicavel      ${ELEMENTOS.btn_publicar}
    realizar clique                 ${ELEMENTOS.btn_publicar}
    Sleep                           3s
    Capture Page Screenshot
    Log To Console    Avaliação publicada com sucesso

*** Test Cases ***
Teste Completo de Avaliação com 3 Estrelas
    [Documentation]    Teste completo: login → filme → formulário → 3 estrelas → publicação
    
    # 1. Configuração inicial
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}
    
    # 2. Login
    fazer login
    
    # 3. Acesso ao filme
    acessar_pagina_filme
    
    # 4. Abrir formulário
    escrever_avaliacao
    
    # 5. Preencher avaliação completa
    preencher_formulario_avaliacao
    ...    titulo=Minha Avaliação Automatizada
    ...    descricao=Ótimo filme, recomendo!
    
    # 6. Publicar avaliação
    submeter_avaliacao
    
    # 7. Verificar sucesso (adicione verificações conforme necessário)
    Wait Until Page Contains    Avaliação publicada com sucesso    timeout=${TIMEOUT}
    
    # 8. Finalização
    Close Browser