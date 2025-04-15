@echo off
cls
mode con: cols=80 lines=30
title Burgies I Serials

echo ==========================
echo        BIOS Information
wmic bios get serialnumber
wmic csproduct get uuid

echo ==========================
echo        CPU Information
wmic cpu get serialnumber
wmic cpu get processorid

echo ==========================
echo        Disk Drive Information
wmic diskdrive get serialnumber

echo ==========================
echo        Baseboard Information
wmic baseboard get serialnumber
wmic baseboard get manufacturer

echo ==========================
echo        Network Adapter Information
wmic path Win32_NetworkAdapter where "PNPDeviceID like '%%PCI%%' AND NetConnectionStatus=2 AND AdapterTypeID='0'" get MacAddress

echo ==========================
pause >nul
