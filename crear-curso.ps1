param(
    [Parameter(Mandatory=$true)]
    [string]$CourseCode,

    [Parameter(Mandatory=$true)]
    [string]$Month,

    [Parameter(Mandatory=$true)]
    [string]$Center
)

$basePath = "C:\GithubOrden"

$templatesPath = "$basePath\training-templates"
$deliveryPath = "$basePath\training-delivery"

$templateCourse = "$templatesPath\$CourseCode"

$versionName = "$Center-$Month"
$courseDeliveryRoot = "$deliveryPath\$CourseCode"
$newDelivery = "$courseDeliveryRoot\$versionName"

Write-Host "======================================="
Write-Host "Creando entrega de curso"
Write-Host "Curso:  $CourseCode"
Write-Host "Centro: $Center"
Write-Host "Mes:    $Month"
Write-Host "======================================="

if (!(Test-Path $templateCourse)) {
    Write-Host "[ERROR] No existe el curso base:"
    Write-Host $templateCourse
    exit 1
}

if (Test-Path $newDelivery) {
    Write-Host "[ERROR] Esta ejecucion ya existe:"
    Write-Host $newDelivery
    exit 1
}

New-Item -ItemType Directory -Path $courseDeliveryRoot -Force | Out-Null

Write-Host "[OK] Copiando template..."
Copy-Item -Path $templateCourse -Destination $newDelivery -Recurse -Force

Write-Host "[OK] Curso creado:"
Write-Host $newDelivery

Set-Location $deliveryPath

git add .

$changes = git status --porcelain

if ($changes) {
    git commit -m "Add $CourseCode $versionName delivery"
    git push
}
else {
    Write-Host "[INFO] No hay cambios para subir."
}

Write-Host "======================================="
Write-Host "[OK] Proceso terminado"
Write-Host "======================================="