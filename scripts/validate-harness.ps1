param(
    [string]$Root = "."
)

$ErrorActionPreference = "Stop"

$resolvedRoot = (Resolve-Path -Path $Root).Path
$errors = New-Object System.Collections.Generic.List[string]

# --- Counters for summary ---
$counts = @{
    RootFiles       = 0
    Templates       = 0
    ProjectRulebooks = 0
    Manifests       = 0
    PromptSpecs     = 0
    RoutingRefs     = 0
    AgentMemories   = 0
}

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

# =============================================================================
# 1. Root files
# =============================================================================

$agentsPath = Join-Path $resolvedRoot "AGENTS.md"
if (-not (Test-Path -LiteralPath $agentsPath)) {
    Add-ValidationError "Root AGENTS.md is missing."
} else {
    $counts.RootFiles++
}

$csharpReadmePath = Join-Path $resolvedRoot "c#/README.md"
if (Test-Path -LiteralPath (Join-Path $resolvedRoot "c#")) {
    if (-not (Test-Path -LiteralPath $csharpReadmePath)) {
        Add-ValidationError "c#/README.md is missing while c#/ exists."
    } else {
        $counts.RootFiles++
    }
}

# =============================================================================
# 2. Cross-reference validation for AGENTS.md routing table
# =============================================================================

if (Test-Path -LiteralPath $agentsPath) {
    $agentsContent = Get-Content -LiteralPath $agentsPath -Raw

    # Extract backtick-quoted file paths from the routing table rows
    $routingMatches = [regex]::Matches($agentsContent, '\|\s*`([^`]+\.(md|json))`\s*\|')
    foreach ($routingMatch in $routingMatches) {
        $referencedPath = $routingMatch.Groups[1].Value

        # Skip paths with placeholders like {ProjectName} or {stack}
        if ($referencedPath -match '\{') {
            continue
        }

        $fullPath = Join-Path $resolvedRoot $referencedPath
        if (-not (Test-Path -LiteralPath $fullPath)) {
            Add-ValidationError "AGENTS.md routing table references '$referencedPath' but the file does not exist."
        }
        $counts.RoutingRefs++
    }
}

# =============================================================================
# 3. Thoughts workspace
# =============================================================================

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
        $counts.Templates++
    }
}

# =============================================================================
# 4. C# project rulebooks
# =============================================================================

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
            $counts.ProjectRulebooks++
        }
    }
}

# =============================================================================
# 5. Feature manifests
# =============================================================================

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
    $counts.Manifests++
}

# =============================================================================
# 6. Prompt specs
# =============================================================================

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
    $counts.PromptSpecs++
}

# =============================================================================
# 7. Agent memory format validation
# =============================================================================

$agentMemoryFiles = Get-ChildItem -LiteralPath $resolvedRoot -Recurse -Filter "AGENT_MEMORY.md" -File
foreach ($memoryFile in $agentMemoryFiles) {
    $relativePath = Resolve-Path -LiteralPath $memoryFile.FullName -Relative
    $content = Get-Content -LiteralPath $memoryFile.FullName -Raw

    foreach ($heading in @(
        "## Current Context",
        "## Goal",
        "## Current State",
        "## Next Steps"
    )) {
        if ($content -notmatch [regex]::Escape($heading)) {
            Add-ValidationError "${relativePath}: missing required heading '$heading'."
        }
    }
    $counts.AgentMemories++
}

# =============================================================================
# Output
# =============================================================================

if ($errors.Count -gt 0) {
    Write-Host "Harness validation failed:" -ForegroundColor Red
    foreach ($validationError in $errors) {
        Write-Host "- $validationError" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host ("Validated: {0} root files, {1} templates, {2} project rulebooks, {3} manifests, {4} prompt-specs, {5} routing refs, {6} agent memories." -f `
        $counts.RootFiles, $counts.Templates, $counts.ProjectRulebooks, `
        $counts.Manifests, $counts.PromptSpecs, $counts.RoutingRefs, `
        $counts.AgentMemories) -ForegroundColor Yellow
    exit 1
}

Write-Host "Harness validation passed." -ForegroundColor Green
Write-Host ("Validated: {0} root files, {1} templates, {2} project rulebooks, {3} manifests, {4} prompt-specs, {5} routing refs, {6} agent memories." -f `
    $counts.RootFiles, $counts.Templates, $counts.ProjectRulebooks, `
    $counts.Manifests, $counts.PromptSpecs, $counts.RoutingRefs, `
    $counts.AgentMemories) -ForegroundColor Green

