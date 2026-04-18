param(
    [Parameter(Mandatory=$true)]
    [string]$CourseCode
)

$basePath = "C:\GithubOrden"

$labsPath = "$basePath\training-templates"
$deliveryPath = "$basePath\training-delivery"

$templateLabs = "$labsPath\$CourseCode-TEMPLATE"
$templateDelivery = "$deliveryPath\$CourseCode\TEMPLATE"

Write-Host "======================================="
Write-Host "Creando TEMPLATE para: $CourseCode"
Write-Host "======================================="

# Crear estructura labs
New-Item -ItemType Directory -Path $templateLabs -Force | Out-Null
New-Item -ItemType Directory -Path "$templateLabs\demos" -Force | Out-Null
New-Item -ItemType Directory -Path "$templateLabs\labs" -Force | Out-Null
New-Item -ItemType Directory -Path "$templateLabs\prompts" -Force | Out-Null

# Crear archivos con contenido (importante para git)
Set-Content "$templateLabs\README.md" "# $CourseCode Template"

Set-Content "$templateLabs\demos\demo-texto.md" "Demo texto"
Set-Content "$templateLabs\demos\demo-vision.md" "Demo vision"
Set-Content "$templateLabs\demos\demo-nlp.md" "Demo NLP"
Set-Content "$templateLabs\demos\demo-agente.md" "Demo agente"

Set-Content "$templateLabs\labs\lab-1.md" "Lab 1"
Set-Content "$templateLabs\labs\lab-2.md" "Lab 2"

Set-Content "$templateLabs\prompts\prompts.md" "Prompts base"

# Crear estructura delivery
New-Item -ItemType Directory -Path "$deliveryPath\$CourseCode" -Force | Out-Null
New-Item -ItemType Directory -Path $templateDelivery -Force | Out-Null

Set-Content "$templateDelivery\plan-clases.md" "Plan de clases"
Set-Content "$templateDelivery\timing.md" "Timing"
Set-Content "$templateDelivery\notas.md" "Notas"
Set-Content "$templateDelivery\checklist.md" "Checklist"
Set-Content "$templateDelivery\sales-angle.md" "Ventas"

Write-Host "✅ TEMPLATE creado correctamente"

# Git labs
Set-Location $labsPath
git add .
git commit -m "Add $CourseCode template labs"
git push

# Git delivery
Set-Location $deliveryPath
git add .
git commit -m "Add $CourseCode template delivery"
git push

Write-Host "🚀 TEMPLATE subido correctamente"