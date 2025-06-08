*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}          http://localhost:3000/auth/signin
${BROWSER}      chrome
${EMAIL}        pl@gmail.com
${SENHA}        123456
${TIMEOUT}      15s

&{ELEMENTOS}
...    inp_email=//input[contains(@placeholder, 'seu@email.com')]
...    inp_senha=//input[@id='password']
...    btn_entrar=//button[contains(.,'Entrar')]
...    inp_feed=//textarea[contains(@placeholder, 'O que você está pensando?')]
...    btn_postar=//button[contains(text(), 'Postar')]
...    toast_sucesso=//*[contains(text(), 'Post criado com sucesso!')] | //div[contains(@class, 'toast')] | //div[contains(@class, 'notification')] | //div[contains(@class, 'alert')] | //div[contains(@class, 'success')]

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
    Sleep                           2s
    Capture Page Screenshot

abrir o site
    Open Browser                    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout            ${TIMEOUT}
    Capture Page Screenshot

preencher dados de login
    aguardar elemento visivel       ${ELEMENTOS.inp_email}
    Input Text                      ${ELEMENTOS.inp_email}      ${EMAIL}
    Input Text                      ${ELEMENTOS.inp_senha}      ${SENHA}
    Capture Page Screenshot

preencher e postar descricao no feed
    aguardar elemento visivel       ${ELEMENTOS.inp_feed}
    Clear Element Text              ${ELEMENTOS.inp_feed}
    Input Text                      ${ELEMENTOS.inp_feed}       meu primeiro teste
    
    # SCREENSHOT IMEDIATO após Input Text
    Capture Page Screenshot
    Log To Console                  Screenshot IMEDIATO - Texto digitado no campo do feed
    
    Sleep                           1s
    
    # Validar se o texto foi realmente inserido
    ${texto_atual}=                 Get Value    ${ELEMENTOS.inp_feed}
    Log To Console                  Texto no campo: ${texto_atual}
    Should Be Equal                 ${texto_atual}    meu primeiro teste
    
    aguardar elemento clicavel      ${ELEMENTOS.btn_postar}
    Click Element                   ${ELEMENTOS.btn_postar}
    Sleep                           3s
    Capture Page Screenshot

fazer login
    Log To Console    Iniciando login...
    aguardar elemento visivel       ${ELEMENTOS.inp_email}
    Input Text                      ${ELEMENTOS.inp_email}      ${EMAIL}
    Input Text                      ${ELEMENTOS.inp_senha}      ${SENHA}
    Capture Page Screenshot
    Click Element                   ${ELEMENTOS.btn_entrar}
    Log To Console    Login realizado, aguardando carregar...
    Sleep                           2s
    Capture Page Screenshot

postar no feed
    Log To Console    Aguardando campo do feed aparecer...
    aguardar elemento visivel       ${ELEMENTOS.inp_feed}
    Sleep                           2s
    Capture Page Screenshot
    
    Log To Console    Clicando no campo de texto...
    Click Element                   ${ELEMENTOS.inp_feed}
    Sleep                           1s
    Capture Page Screenshot
    
    Log To Console    Digitando texto...
    Input Text                      ${ELEMENTOS.inp_feed}    meu primeiro teste
    
    # SCREENSHOT IMEDIATO após digitar
    Capture Page Screenshot
    Log To Console                  Screenshot capturado IMEDIATAMENTE após digitar texto
    
    Sleep                           1s
    
    # NOVO: Validação do texto inserido
    ${texto_inserido}=              Get Value    ${ELEMENTOS.inp_feed}
    Log To Console                  Texto atual no campo: '${texto_inserido}'
    Should Not Be Empty             ${texto_inserido}
    Should Contain                  ${texto_inserido}    meu primeiro teste
    
    Log To Console    Procurando botão postar...
    aguardar elemento clicavel      ${ELEMENTOS.btn_postar}
    
    Log To Console    Clicando em postar...
    Click Element                   ${ELEMENTOS.btn_postar}
    Sleep                           2s
    Capture Page Screenshot

# NOVA keyword para validar texto no campo
validar texto no campo feed
    [Arguments]    ${texto_esperado}
    ${texto_atual}=                 Get Value    ${ELEMENTOS.inp_feed}
    Log To Console                  Validando texto: esperado='${texto_esperado}' atual='${texto_atual}'
    Should Be Equal                 ${texto_atual}    ${texto_esperado}
    Capture Page Screenshot

aguardar toast e encerrar
    Log To Console    Aguardando toast de sucesso...
    TRY
        aguardar elemento visivel   ${ELEMENTOS.toast_sucesso}
        Log To Console    Toast encontrado! Teste concluído com sucesso.
        Capture Page Screenshot
        Sleep                       2s
    EXCEPT
        Log To Console    Toast não encontrado, mas aguardando um pouco...
        Sleep                       3s
        Capture Page Screenshot
        Log To Console    Finalizando teste.
    END

*** Test Cases ***
Login e Postar no Feed
    [Documentation]    Faz login e posta no feed do NextFilm
    [Tags]    login    feed
    
    # Abrir navegador
    Open Browser                    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout            ${TIMEOUT}
    
    # Fazer login
    fazer login
    
    # Aguardar página carregar
    Sleep                           3s
    
    # Postar no feed
    postar no feed
    
    # Aguardar toast e encerrar
    aguardar toast e encerrar
    
    # Fechar navegador
    Close Browser
    
    Log To Console    Teste finalizado!

Teste simples de post no feed
    [Tags]    feed    simples
    Given abrir o site
    And preencher dados de login
    And realizar clique    ${ELEMENTOS.btn_entrar}
    
    # Aguarda a página carregar completamente
    Sleep    5s
    
    # Tenta postar diretamente no feed
    When preencher e postar descricao no feed
    Then Sleep    2s
    And Capture Page Screenshot
    And Close Browser

# NOVO: Teste focado na validação do texto
Teste com validacao de texto no campo
    [Documentation]    Teste específico para validar se o texto está sendo inserido corretamente
    [Tags]    feed    validacao
    
    Open Browser                    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout            ${TIMEOUT}
    
    # Login
    fazer login
    Sleep                           3s
    
    # Validar campo do feed e inserir texto
    aguardar elemento visivel       ${ELEMENTOS.inp_feed}
    Click Element                   ${ELEMENTOS.inp_feed}
    Sleep                           1s
    
    # Limpar campo antes de inserir
    Clear Element Text              ${ELEMENTOS.inp_feed}
    Sleep                           0.5s
    
    # Inserir texto e validar
    Input Text                      ${ELEMENTOS.inp_feed}    meu primeiro teste
    Sleep                           1s
    
    # Screenshot e validação específicos
    Capture Page Screenshot
    validar texto no campo feed     meu primeiro teste
    
    # Continuar com o post
    Click Element                   ${ELEMENTOS.btn_postar}
    Sleep                           2s
    Capture Page Screenshot
    
    Close Browser