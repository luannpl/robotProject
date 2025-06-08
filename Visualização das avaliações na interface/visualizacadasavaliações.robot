*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${URL}          http://localhost:3000/auth/signin
${BROWSER}      chrome
${EMAIL}        teste3@gmail.com
${SENHA}        teste123
${TIMEOUT}      15s

&{ELEMENTOS}
...    inp_email=//input[contains(@placeholder, 'seu@email.com')]
...    inp_senha=//input[@id='password']
...    btn_entrar=//button[contains(.,'Entrar')]
...    link_filme=//h3[contains(text(),'Lilo & Stitch')]/ancestor::a  # Localizador mais confiável
...    sec_avaliacoes=//h2[contains(text(),'Avaliações')] | //div[contains(@class,'reviews')]
...    btn_escrever_avaliacao=//button[contains(text(),'Escrever avaliação')]
...    card_avaliacao=//div[contains(@class,'review-card')]  # Ajuste conforme sua estrutura

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
    Sleep                           1s
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

verificar_secao_avaliacoes
    Log To Console    Verificando seção de avaliações...
    aguardar elemento visivel       ${ELEMENTOS.sec_avaliacoes}
    ${count}=    Get Element Count    ${ELEMENTOS.card_avaliacao}
    Run Keyword If    ${count} > 0    Log To Console    ${count} avaliações encontradas
    ...    ELSE    Log To Console    Nenhuma avaliação encontrada
    Capture Page Screenshot

*** Test Cases ***
Acessar Avaliacoes do Filme
    [Documentation]    Testa o acesso às avaliações de um filme específico
    [Tags]    filme    avaliacoes
    
    # 1. Abrir navegador e fazer login
    Open Browser                    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout            ${TIMEOUT}
    fazer login
    
    # 2. Acessar página do filme
    acessar_pagina_filme
    
    # 3. Verificar seção de avaliações
    verificar_secao_avaliacoes
    
    # 4. Verificar se o botão "Escrever avaliação" está visível (opcional)
    Run Keyword And Continue On Failure    aguardar elemento visivel    ${ELEMENTOS.btn_escrever_avaliacao}
    
    # 5. Encerrar
    Sleep                           2s
    Capture Page Screenshot
    Close Browser