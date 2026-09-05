param(
    [Parameter(Mandatory=$true)]
    [string]$CourseCode
)

$basePath = "C:\GithubOrden"
$templatesPath = "$basePath\training-templates"
$coursePath = "$templatesPath\$CourseCode"

Write-Host "======================================="
Write-Host "Creando template de curso"
Write-Host "Curso: $CourseCode"
Write-Host "======================================="

if (Test-Path $coursePath) {
    Write-Host "[ERROR] El curso ya existe:"
    Write-Host $coursePath
    exit 1
}

New-Item -ItemType Directory -Path $coursePath -Force | Out-Null

$folders = @(
    "demos",
    "labs",
    "prompts",
    "scripts",
    "datasets"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Path "$coursePath\$folder" -Force | Out-Null
}

@"
# $CourseCode

Template reutilizable del curso $CourseCode.

## Estructura

- demos: demostraciones para clase
- labs: ejercicios practicos
- prompts: prompts utilizados durante el curso
- scripts: scripts PowerShell, CLI, Python u otros
- datasets: archivos de datos utilizados en demos o labs

## Regla

Este directorio contiene solo material reutilizable.

Las ejecuciones por centro y fecha se crean en training-delivery.
"@ | Set-Content "$coursePath\README.md"

@"
# Demos

Colocar aqui las demostraciones reutilizables del curso.
"@ | Set-Content "$coursePath\demos\README.md"

@"
# Labs

Colocar aqui los laboratorios y ejercicios practicos.
"@ | Set-Content "$coursePath\labs\README.md"

@"
# Prompts

Colocar aqui los prompts utilizados durante el curso.
"@ | Set-Content "$coursePath\prompts\README.md"

@"
# Scripts

Colocar aqui los scripts utilizados durante demos y labs.
"@ | Set-Content "$coursePath\scripts\README.md"

@"
# Datasets

Colocar aqui datasets o archivos de ejemplo necesarios para demos o labs.
"@ | Set-Content "$coursePath\datasets\README.md"

Write-Host "[OK] Template creado:"
Write-Host $coursePath

Set-Location $templatesPath

git add .

$changes = git status --porcelain

if ($changes) {
    git commit -m "Add $CourseCode training template"
    git push
}
else {
    Write-Host "[INFO] No hay cambios para subir."
}

Write-Host "======================================="
Write-Host "[OK] Proceso terminado"
Write-Host "======================================="
