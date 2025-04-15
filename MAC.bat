@shift /0
@ECHO OFF
title ext
SETLOCAL ENABLEDELAYEDEXPANSION
SETLOCAL ENABLEEXTENSIONS

:: Generar e implementar una dirección MAC aleatoria
FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
    CALL :MAC
    FOR %%b IN (0 00 000) DO (
        REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v NetworkAddress /t REG_SZ /d !MAC! /f >NUL 2>NUL
    )
)

:: Desactivar el modo de ahorro de energía para los adaptadores de red
FOR /F "tokens=1" %%a IN ('wmic nic where physicaladapter^=true get deviceid ^| findstr [0-9]') DO (
    FOR %%b IN (0 00 000) DO (
        REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a >NUL 2>NUL && REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%%b%%a /v PnPCapabilities /t REG_DWORD /d 24 /f >NUL 2>NUL
    )
)

:: Restablecer los adaptadores NIC para que se aplique la nueva dirección MAC y se desactive el modo de ahorro de energía
FOR /F "tokens=2 delims=, skip=2" %%a IN ('"wmic nic where (netconnectionid like '%%') get netconnectionid,netconnectionstatus /format:csv"') DO (
    netsh interface set interface name="%%a" disable >NUL 2>NUL
    netsh interface set interface name="%%a" enable >NUL 2>NUL
)

:: Llamar al archivo .vbs para mostrar el MessageBox
echo Set WshShell = CreateObject("WScript.Shell") > show_message.vbs
echo WshShell.Popup "Mac changed Successfully!", 5, "Success", 64 >> show_message.vbs
cscript //nologo show_message.vbs
del show_message.vbs

GOTO :EOF

:MAC
:: Genera un valor semi-aleatorio de acuerdo a la longitud de la "if !COUNT!" línea, menos uno, y de los caracteres en la variable GEN
SET COUNT=0
SET GEN=ABCDEF0123456789
SET GEN2=26AE
SET MAC=
:MACLOOP
SET /a COUNT+=1
SET RND=%random%
:: %%n, donde el valor de n es el número de caracteres en GEN menos uno. Entonces si tienes 15 caracteres en GEN, pon el número como 14
SET /A RND=RND%%16
SET RNDGEN=!GEN:~%RND%,1!
SET /A RND2=RND%%4
SET RNDGEN2=!GEN2:~%RND2%,1!
IF "!COUNT!"  EQU "2" (SET MAC=!MAC!!RNDGEN2!) ELSE (SET MAC=!MAC!!RNDGEN!)
IF !COUNT!  LEQ 11 GOTO MACLOOP
