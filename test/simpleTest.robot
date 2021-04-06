*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
open a browser at that URL
    Open Browser    https://www.monext.fr    ff
    Maximize Browser Window

check if the web site is up
    wait until element is visible    header-logo

Close browser
    close browser
