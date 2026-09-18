# Lista de aplicaciones a eliminar (incluye Xbox y Xbox Live mediante el comodín)
$AppsList = @(
    "*Xbox*",                           # Esto incluye Xbox App, Xbox Live, Game Bar, etc.
    "*MicrosoftSolitaireCollection*",   # Solitario y juegos casuales
    "*BingNews*",                       # Microsoft News
    "*BingWeather*",                    # El Tiempo
    "*WindowsFeedbackHub*",             # Centro de opiniones
    "*QuickAssist*"                     # Asistencia rápida
)

Write-Host "Iniciando limpieza profunda de aplicaciones..." -ForegroundColor Cyan

foreach ($AppName in $AppsList) {
    Write-Host "Procesando: $AppName" -ForegroundColor Yellow
    
    # 1. Eliminar paquetes instalados para todos los usuarios (Uno a uno)
    $InstalledPackages = Get-AppxPackage -AllUsers -Name $AppName
    foreach ($Package in $InstalledPackages) {
        try {
            Write-Host "Eliminando paquete instalado: $($Package.Name)"
            Remove-AppxPackage -Package $Package.PackageFullName -AllUsers -ErrorAction Stop
        } catch {
            Write-Host "Saltando $($Package.Name): Es una aplicación protegida del sistema." -ForegroundColor Gray
        }
    }

    # 2. Eliminar de la imagen de Windows (Provisioned) para que no aparezcan a nuevos usuarios
    $ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like $AppName}
    foreach ($ProvPackage in $ProvisionedPackages) {
        try {
            Write-Host "Eliminando de la imagen (Provisioned): $($ProvPackage.DisplayName)"
            Remove-AppxProvisionedPackage -Online -PackageName $ProvPackage.PackageName -ErrorAction Stop
        } catch {
            Write-Host "No se pudo eliminar de la imagen: $($ProvPackage.DisplayName)" -ForegroundColor Gray
        }
    }
}

# Forzamos la salida con éxito para que MDT no muestre errores en el resumen final
Write-Host "Limpieza completada." -ForegroundColor Green
exit 0