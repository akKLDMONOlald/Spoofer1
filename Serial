@echo off
cls
mode con: cols=50 lines=35
title Burgies | System Serials

echo.
echo [90m==============================================[97m
echo             [96m[ SYSTEM INFORMATION ][97m
echo [90m==============================================[97m

echo.
echo [93m[BIOS][97m
wmic bios get serialnumber
wmic csproduct get uuid

echo.
echo [93m[CPU][97m
wmic cpu get serialnumber
wmic cpu get processorid

echo.
echo [93m[Disk Drive][97m
wmic diskdrive get serialnumber

echo.
echo [93m[Motherboard][97m
wmic baseboard get serialnumber
wmic baseboard get manufacturer

echo.
echo [93m[Active Network MAC][97m
wmic path Win32_NetworkAdapter where "PNPDeviceID like '%%PCI%%' AND NetConnectionStatus=2 AND AdapterTypeID='0'" get MacAddress

echo.
echo [90m==============================================[97m
echo               [92m[ PROCESS COMPLETED ][97m
echo [90m==============================================[97m
echo.
pause >nul
