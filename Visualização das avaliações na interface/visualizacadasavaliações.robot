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
...    link_filme=//h3[contains(text(),'Lilo & Stitch')]/ancestor::a


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

*** Test Cases ***
Teste de Acesso à Página do Filme
    [Documentation]    Teste mínimo: login e acesso à página do filme
    
    # 1. Abrir navegador
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}
    
    # 2. Fazer login e acessar filme (já incluso no "acessar_pagina_filme")
    fazer login
    acessar_pagina_filme
    
    # 3. Fechar navegador imediatamente após carregar a página
    Close Browser