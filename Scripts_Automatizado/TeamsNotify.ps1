# --- CONFIGURACIÓN ---
$TeamsWebhookURL = "https://aimen.webhook.office.com/webhookb2/c328b05d-2aca-414e-a30f-02289ccbcbd9@5f987cf6-7ac6-4827-a43e-29d1a748e2bc/IncomingWebhook/503269e9403f488fa0f844a60bbdbcf8/759128b4-3c63-4cb9-8097-f2cbcb4fb4e5/V2LnD8kVVfKNu6vSUklChPiVgvWNXWsY-H_dSwdy8aiVI1"

# --- OBTENER DATOS DEL EQUIPO ---
$ComputerName = $env:COMPUTERNAME
$Model = (Get-WmiObject -Class:Win32_ComputerSystem).Model

# 1. Obtener la IP (Cogemos la primera IPv4 válida que no sea localhost)
$IPAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" } | Select-Object -First 1).IPAddress

# 2. Obtener Fecha y Hora de finalización
$FechaHora = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

# 3. Conectar a MDT para revisar los errores
$Estado = "Actualizado y Limpio"
$DetalleErrores = "Ninguno"

try {
    # Conectamos con el entorno en vivo de MDT
    $TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    $MDTErrorCount = $TSEnv.Value("ErrorCount")
    
    # Si el contador de errores es mayor que 0, cambiamos el mensaje
    if ([int]$MDTErrorCount -gt 0) {
        $Estado = "Finalizado con Errores"
        $DetalleErrores = "MDT registró $MDTErrorCount error(es) durante la Task Sequence."
    }
} catch {
    # Por si se ejecuta el script a mano fuera de un despliegue de MDT
    $DetalleErrores = "No se pudo leer el estado (Ejecución fuera de MDT)"
}

# --- CONSTRUIR EL MENSAJE (JSON) ---
$Body = @{
    "@type" = "MessageCard"
    "@context" = "http://schema.org/extensions"
    "themeColor" = "0076D7"
    "summary" = "Despliegue Finalizado: $ComputerName"
    "sections" = @(@{
        "activityTitle" = " **Instalación Completada**"
        "activitySubtitle" = "Resumen del equipo tras el despliegue:"
        "facts" = @(
            @{ "name" = "Nombre del PC:"; "value" = $ComputerName }
            @{ "name" = "Modelo:"; "value" = $Model }
            @{ "name" = "Dirección IP:"; "value" = $IPAddress }
            @{ "name" = "Hora de fin:"; "value" = $FechaHora }
            @{ "name" = "Estado General:"; "value" = $Estado }
            @{ "name" = "Avisos MDT:"; "value" = $DetalleErrores }
        )
        "markdown" = $true
    })
} | ConvertTo-Json -Depth 10

# --- ENVÍO A TEAMS ---
Invoke-RestMethod -Uri $TeamsWebhookURL -Method Post -Body $Body -ContentType 'application/json'
exit 0