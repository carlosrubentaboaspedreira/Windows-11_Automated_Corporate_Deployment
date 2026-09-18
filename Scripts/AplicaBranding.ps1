# =========================================================
# SCRIPT DE BRANDING INTEGRADO - TABOAS SL
# Incluye: Información OEM y Plan B para Pantalla de Bloqueo
# =========================================================

# --- 1. CONFIGURACIÓN DE INFORMACIÓN OEM ---
$DestinoLogo = "C:\Windows\Branding\OEM"
$OrigenLogo = "$PSScriptRoot\oemlogo.bmp"
$RegKeyOEM = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"

If (!(Test-Path $DestinoLogo)) { New-Item -Path $DestinoLogo -ItemType Directory -Force }
if (Test-Path $OrigenLogo) { Copy-Item -Path $OrigenLogo -Destination "$DestinoLogo\oemlogo.bmp" -Force }

Set-ItemProperty -Path $RegKeyOEM -Name "Manufacturer" -Value "TABOAS SL"
Set-ItemProperty -Path $RegKeyOEM -Name "Logo" -Value "$DestinoLogo\oemlogo.bmp"
Set-ItemProperty -Path $RegKeyOEM -Name "SupportHours" -Value "Lunes a Viernes (8:00 - 15:00)"
Set-ItemProperty -Path $RegKeyOEM -Name "SupportPhone" -Value "+34 986 11 22 33"


# --- 2. PLAN B: PANTALLA DE BLOQUEO (FORZADO PARA WIN PRO) ---
$RutaWebScreen = "C:\Windows\Web\Screen"
$OrigenLock = "$PSScriptRoot\lockscreen.jpg"

if (Test-Path $OrigenLock) {
    # Tomamos posesión de la carpeta de imágenes de Windows para poder escribir
    # Esto es necesario porque incluso el Admin tiene permisos restringidos aquí
    takeown /f $RutaWebScreen /r /d s
    icacls $RutaWebScreen /grant "administradores:(OI)(CI)F" /t

    # Sobreescribimos la imagen por defecto de Windows (img100.jpg)
    # Windows 11 Pro usa este archivo como base para la pantalla de bloqueo
    Copy-Item -Path $OrigenLock -Destination "$RutaWebScreen\img100.jpg" -Force
    
    # Por seguridad, sobreescribimos también la img105 que a veces se usa de backup
    Copy-Item -Path $OrigenLock -Destination "$RutaWebScreen\img105.jpg" -Force
}

# --- 3. LIMPIEZA DE CACHÉ DE IMÁGENES ---
# Esto obliga a Windows a regenerar la vista previa de la pantalla de bloqueo
$PathCache = "$env:ProgramData\Microsoft\Windows\SystemData"
# Nota: Esta carpeta es muy restrictiva, el script la limpiará durante el despliegue (SYSTEM)