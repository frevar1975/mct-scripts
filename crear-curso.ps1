param(
    [Parameter(Mandatory=$true)]
    [string]$CourseCode,

    [Parameter(Mandatory=$true)]
    [string]$Date,

    [Parameter(Mandatory=$true)]
    [string]$Center
)

$basePath = "C:\GithubOrden"

$templatesPath = "$basePath\training-templates"
$deliveryPath = "$basePath\training-delivery"

$templateCourse = "$templatesPath\$CourseCode"

$deliveryName = "$Center-$Date"
$courseDeliveryRoot = "$deliveryPath\$CourseCode"
$newDelivery = "$courseDeliveryRoot\$deliveryName"

Write-Host "======================================="
Write-Host "Creando entrega de curso"
Write-Host "Curso:  $CourseCode"
Write-Host "Centro: $Center"
Write-Host "Fecha:  $Date"
Write-Host "======================================="

if (!(Test-Path $templateCourse)) {
    Write-Host "[ERROR] No existe el curso base:"
    Write-Host $templateCourse
    exit 1
}

if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    Write-Host "[ERROR] La fecha debe tener formato YYYY-MM-DD"
    exit 1
}

if (Test-Path $newDelivery) {
    Write-Host "[ERROR] Esta entrega ya existe:"
    Write-Host $newDelivery
    exit 1
}

New-Item -ItemType Directory -Path $courseDeliveryRoot -Force | Out-Null

Write-Host "[OK] Copiando template..."

Copy-Item `
    -Path $templateCourse `
    -Destination $newDelivery `
    -Recurse `
    -Force

Write-Host "[OK] Curso creado:"
Write-Host $newDelivery

Set-Location $deliveryPath

git add .

$changes = git status --porcelain

if ($changes) {
    git commit -m "Add $CourseCode delivery $deliveryName"
    git push
}
else {
    Write-Host "[INFO] No hay cambios para subir."
}

Write-Host "======================================="
Write-Host "[OK] Proceso terminado"
Write-Host "======================================="