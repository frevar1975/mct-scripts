param(
    [Parameter(Mandatory=$true)]
    [string]$CourseCode,

    [Parameter(Mandatory=$true)]
    [string]$Month,

    [Parameter(Mandatory=$true)]
    [string]$Center
)

$basePath = "C:\GithubOrden"

$labsPath = "$basePath\training-labs"
$deliveryPath = "$basePath\training-delivery"

$templateLabs = "$labsPath\$CourseCode-TEMPLATE"
$templateDelivery = "$deliveryPath\$CourseCode\TEMPLATE"

$versionName = "$Center-$Month"

$newLabs = "$labsPath\$CourseCode-$versionName"
$newDelivery = "$deliveryPath\$CourseCode\$versionName"

Write-Host "======================================="
Write-Host "Creando curso: $CourseCode"
Write-Host "Centro: $Center"
Write-Host "Mes: $Month"
Write-Host "======================================="

# Validar templates
if (!(Test-Path $templateLabs)) {
    Write-Host "❌ No existe TEMPLATE en training-labs"
    exit
}

if (!(Test-Path $templateDelivery)) {
    Write-Host "❌ No existe TEMPLATE en training-delivery"
    exit
}

# Copiar LABS
Write-Host "📦 Copiando labs..."
Copy-Item -Recurse -Force $templateLabs $newLabs

# Copiar DELIVERY
Write-Host "📦 Copiando delivery..."
Copy-Item -Recurse -Force $templateDelivery $newDelivery

# Limpiar carpeta TEMPLATE interna si existe
if (Test-Path "$newDelivery\TEMPLATE") {
    Remove-Item -Recurse -Force "$newDelivery\TEMPLATE"
}

Write-Host "✅ Curso creado correctamente"

# Git LABS
Set-Location $labsPath
git add .
git commit -m "Add $CourseCode $versionName labs"
git push

# Git DELIVERY
Set-Location $deliveryPath
git add .
git commit -m "Add $CourseCode $versionName delivery"
git push

Write-Host "🚀 Curso subido a GitHub"