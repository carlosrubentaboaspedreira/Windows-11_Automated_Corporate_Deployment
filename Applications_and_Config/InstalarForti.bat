@echo off
:: Instala el programa
"FortiClientSetup_6.0.9.0277_x64.exe" /quiet /norestart
:: Importa la configuración de la VPN de AIMEN
reg.exe import "AIMEN_VPN.reg"