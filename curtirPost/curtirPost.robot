*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}          http://localhost:3000/auth/signin
${BROWSER}      chrome
${EMAIL}        pl@gmail.com
${SENHA}        123456
${TEXTO_POST}   Meu filme favorito

&{ELEMENTOS}
...    inp_email=//input[contains(@placeholder, 'seu@email.com')]
...    inp_senha=//input[@id='password']
...    btn_entrar=//button[contains(.,'Entrar')]

*** Keywords ***
abrir o site
    Open Browser                    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout            15s
    Capture Page Screenshot

preencher dados de login
    Wait Until Element Is Visible    ${ELEMENTOS.inp_email}
    Input Text                       ${ELEMENTOS.inp_email}      ${EMAIL}
    Input Text                       ${ELEMENTOS.inp_senha}      ${SENHA}
    Capture Page Screenshot

realizar clique
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element                    ${locator}
    Sleep                            2s
    Capture Page Screenshot

fazer login
    Log To Console    Iniciando login...
    preencher dados de login
    Click Element                   ${ELEMENTOS.btn_entrar}
    Sleep                           2s
    Capture Page Screenshot

curtir post com texto
    [Arguments]    ${texto_post}
    Log To Console    Iniciando curtida no post: ${texto_post}

    ${xpath_botao}=   Set Variable    //div[contains(., '${texto_post}')]/following::button[1]
    Log To Console    XPath final do botão: ${xpath_botao}

    Wait Until Element Is Visible    ${xpath_botao}    timeout=20s
    Scroll Element Into View         ${xpath_botao}
    Sleep                            1s

    Capture Page Screenshot          # Print antes do clique

    Click Element                    ${xpath_botao}
    Sleep                           2s
    Capture Page Screenshot


*** Test Cases ***
Curtir post no feed
    [Documentation]   
    [Tags]    curtida    bdd

    Given abrir o site
    And fazer login
    And Sleep              3s

    When curtir post com texto    ${TEXTO_POST}

    Then Sleep    2s
    And Capture Page Screenshot
    And Close Browser
