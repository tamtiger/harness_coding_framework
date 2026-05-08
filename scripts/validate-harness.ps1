param(
    [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$resolvedRoot = (Resolve-Path -Path $Root).Path
$errors = New-Object System.Collections.Generic.List[string]

$allowedTypes = @("Command", "Query")
$allowedStatuses = @("Complete", "Draft", "NeedsReview")
$allowedLayers = @(
    "Domain.Shared",
    "Domain",
    "Application.Contracts",
    "Application",
    "EntityFrameworkCore",
    "HttpApi",
    "HttpApi.Host",
    "Tests"
)

$requiredThoughtTemplates = @(
    "ticket-template.md",
    "plan-template.md",
    "research-template.md",
    "agent-memory-template.md"
)

$requiredCSharpProjectRulebooks = @(
    "README.md",
    "module-map.md",
    "security-rules.md",
    "observability-rules.md",
    "api-contract-rules.md",
    "testing-rules.md",
    "ci-rules.md"
)

function Add-ValidationError {
    param([string]$Message)
    $errors.Add($Message) | Out-Null
}

function Test-StringProperty {
    param(
        [object]$Object,
        [string]$PropertyName,
        [string]$Path
    )

    $value = $Object.$PropertyName
    if ($null -eq $value -or $value -isnot [string] -or [string]::IsNullOrWhiteSpace($value)) {
        Add-ValidationError "${Path}: '$PropertyName' must be a non-empty string."
    }
}

function Test-ArrayProperty {
    param(
        [object]$Object,
        [string]$PropertyName,
        [string]$Path,
        [bool]$RequireItems = $false
    )

    $value = $Object.$PropertyName
    if ($null -eq $value -or $value -isnot [System.Array]) {
        Add-ValidationError "${Path}: '$PropertyName' must be an array."
        return
    }

    if ($RequireItems -and $value.Count -eq 0) {
        Add-ValidationError "${Path}: '$PropertyName' must contain at least one item."
    }

    $duplicates = $value | Group-Object | Where-Object { $_.Count -gt 1 }
    foreach ($duplicate in $duplicates) {
        Add-ValidationError "${Path}: '$PropertyName' contains duplicate item '$($duplicate.Name)'."
    }
}

$agentsPath = Join-Path $resolvedRoot "AGENTS.md"
if (-not (Test-Path -LiteralPath $agentsPath)) {
    Add-ValidationError "Root AGENTS.md is missing."
}

$csharpReadmePath = Join-Path $resolvedRoot "c#/README.md"
if (Test-Path -LiteralPath (Join-Path $resolvedRoot "c#")) {
    if (-not (Test-Path -LiteralPath $csharpReadmePath)) {
        Add-ValidationError "c#/README.md is missing while c#/ exists."
    }
}

$thoughtsPath = Join-Path $resolvedRoot "thoughts"
if (Test-Path -LiteralPath $thoughtsPath) {
    foreach ($requiredDirectory in @(
        "shared/01-tickets",
        "shared/03-plans",
        "shared/02-research",
        "templates"
    )) {
        $directoryPath = Join-Path $thoughtsPath $requiredDirectory
        if (-not (Test-Path -LiteralPath $directoryPath -PathType Container)) {
            Add-ValidationError "thoughts/$requiredDirectory directory is missing."
        }
    }

    foreach ($templateName in $requiredThoughtTemplates) {
        $templatePath = Join-Path $thoughtsPath "templates/$templateName"
        if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
            Add-ValidationError "thoughts/templates/$templateName is missing."
            continue
        }

        $templateContent = Get-Content -LiteralPath $templatePath -Raw
        if ([string]::IsNullOrWhiteSpace($templateContent)) {
            Add-ValidationError "thoughts/templates/$templateName must not be empty."
        }
    }
}

$csharpProjectsPath = Join-Path $resolvedRoot "c#/projects"
if (Test-Path -LiteralPath $csharpProjectsPath) {
    $projectDirectories = Get-ChildItem -LiteralPath $csharpProjectsPath -Directory
    foreach ($projectDirectory in $projectDirectories) {
        foreach ($rulebookFile in $requiredCSharpProjectRulebooks) {
            $rulebookPath = Join-Path $projectDirectory.FullName $rulebookFile
            $relativeRulebookPath = Resolve-Path -LiteralPath $projectDirectory.FullName -Relative
            if (-not (Test-Path -LiteralPath $rulebookPath -PathType Leaf)) {
                Add-ValidationError "$relativeRulebookPath/$rulebookFile is required for C# project rulebooks."
                continue
            }

            $rulebookContent = Get-Content -LiteralPath $rulebookPath -Raw
            if ([string]::IsNullOrWhiteSpace($rulebookContent)) {
                Add-ValidationError "$relativeRulebookPath/$rulebookFile must not be empty."
            }
        }
    }
}

$manifestFiles = Get-ChildItem -LiteralPath $resolvedRoot -Recurse -Filter "feature-manifest.json" -File
foreach ($manifestFile in $manifestFiles) {
    $relativePath = Resolve-Path -LiteralPath $manifestFile.FullName -Relative

    try {
        $manifest = Get-Content -LiteralPath $manifestFile.FullName -Raw | ConvertFrom-Json
    }
    catch {
        Add-ValidationError "${relativePath}: invalid JSON. $($_.Exception.Message)"
        continue
    }

    Test-StringProperty -Object $manifest -PropertyName "feature" -Path $relativePath
    Test-StringProperty -Object $manifest -PropertyName "module" -Path $relativePath

    if ($manifest.type -notin $allowedTypes) {
        Add-ValidationError "${relativePath}: 'type' must be one of: $($allowedTypes -join ', ')."
    }

    if ($manifest.ai_status -notin $allowedStatuses) {
        Add-ValidationError "${relativePath}: 'ai_status' must be one of: $($allowedStatuses -join ', ')."
    }

    Test-ArrayProperty -Object $manifest -PropertyName "dependencies" -Path $relativePath
    Test-ArrayProperty -Object $manifest -PropertyName "layers_touched" -Path $relativePath -RequireItems $true
    Test-ArrayProperty -Object $manifest -PropertyName "permissions" -Path $relativePath
    Test-ArrayProperty -Object $manifest -PropertyName "events" -Path $relativePath

    foreach ($layer in $manifest.layers_touched) {
        if ($layer -notin $allowedLayers) {
            Add-ValidationError "${relativePath}: unsupported layer '$layer'."
        }
    }

    $promptSpecPath = Join-Path $manifestFile.DirectoryName "prompt-spec.md"
    if (-not (Test-Path -LiteralPath $promptSpecPath)) {
        Add-ValidationError "${relativePath}: sibling prompt-spec.md is required."
    }
}

$promptSpecFiles = Get-ChildItem -LiteralPath $resolvedRoot -Recurse -Filter "prompt-spec.md" -File
foreach ($promptSpecFile in $promptSpecFiles) {
    $relativePath = Resolve-Path -LiteralPath $promptSpecFile.FullName -Relative
    $content = Get-Content -LiteralPath $promptSpecFile.FullName -Raw

    foreach ($heading in @(
        "## Metadata",
        "## Business Goal",
        "## Scope",
        "## Acceptance Criteria"
    )) {
        if ($content -notmatch [regex]::Escape($heading)) {
            Add-ValidationError "${relativePath}: missing required heading '$heading'."
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Harness validation failed:" -ForegroundColor Red
    foreach ($validationError in $errors) {
        Write-Host "- $validationError" -ForegroundColor Red
    }
    exit 1
}

Write-Host "Harness validation passed." -ForegroundColor Green
