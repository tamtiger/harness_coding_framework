<#
.SYNOPSIS
    Sinh source tree (cấu trúc thư mục) của một repo Git dưới dạng Markdown.

.DESCRIPTION
    Script quét thư mục repo, loại bỏ các folder không cần thiết (.git, node_modules, bin, obj, v.v.),
    và xuất ra cấu trúc cây dạng text giống lệnh `tree`. Output có thể lưu trực tiếp vào file .md.

.PARAMETER Path
    Đường dẫn tới thư mục gốc của repo. Mặc định là thư mục hiện tại.

.PARAMETER Depth
    Độ sâu tối đa khi quét thư mục. Mặc định là 4.

.PARAMETER OutputFile
    Đường dẫn file output. Nếu không chỉ định, in ra stdout.

.PARAMETER ExcludeDirs
    Danh sách thư mục cần loại bỏ (phân cách bằng dấu phẩy).
    Mặc định: .git,node_modules,bin,obj,packages,.vs,.idea,__pycache__,.venv,dist,build,TestResults

.PARAMETER IncludeSummaryHeader
    Nếu bật, thêm header Markdown với metadata (repo name, ngày sinh, depth).

.EXAMPLE
    .\generate-source-tree.ps1 -Path "C:\MyRepo" -Depth 3 -OutputFile "tree.md"

.EXAMPLE
    .\generate-source-tree.ps1 -IncludeSummaryHeader
#>

param(
    [string]$Path = ".",
    [int]$Depth = 4,
    [string]$OutputFile = "",
    [string]$ExcludeDirs = ".git,node_modules,bin,obj,packages,.vs,.idea,__pycache__,.venv,dist,build,TestResults",
    [switch]$IncludeSummaryHeader
)

$ErrorActionPreference = "Stop"

# Resolve paths
$resolvedPath = (Resolve-Path -Path $Path).Path
$repoName = Split-Path -Leaf $resolvedPath
$excludeList = $ExcludeDirs -split "," | ForEach-Object { $_.Trim() }

# Tree generation function
function Get-Tree {
    param(
        [string]$DirectoryPath,
        [int]$MaxDepth,
        [int]$CurrentDepth = 0,
        [string]$Prefix = "",
        [string[]]$ExcludeDirectories
    )

    $items = Get-ChildItem -LiteralPath $DirectoryPath | Where-Object {
        if ($_.PSIsContainer) { $_.Name -notin $ExcludeDirectories }
        else { $true }
    } | Sort-Object { -not $_.PSIsContainer }, Name

    $count = $items.Count
    $index = 0

    foreach ($item in $items) {
        $index++
        $isLast = ($index -eq $count)
        $connector = if ($isLast) { "└── " } else { "├── " }
        $childPrefix = if ($isLast) { "    " } else { "│   " }

        Write-Output "$Prefix$connector$($item.Name)"

        if ($item.PSIsContainer -and $CurrentDepth -lt ($MaxDepth - 1)) {
            Get-Tree -DirectoryPath $item.FullName `
                     -MaxDepth $MaxDepth `
                     -CurrentDepth ($CurrentDepth + 1) `
                     -Prefix "$Prefix$childPrefix" `
                     -ExcludeDirectories $ExcludeDirectories
        }
    }
}

# Build output
$output = New-Object System.Collections.Generic.List[string]

if ($IncludeSummaryHeader) {
    $output.Add("# Source Tree: $repoName")
    $output.Add("")
    $output.Add("## Metadata")
    $output.Add("- **Repo**: ``$repoName``")
    $output.Add("- **Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm')")
    $output.Add("- **Depth**: $Depth")
    $output.Add("- **Excluded**: ``$ExcludeDirs``")
    $output.Add("")
    $output.Add("## Tree")
    $output.Add("")
}

$output.Add('```text')
$output.Add("$repoName/")

$treeLines = Get-Tree -DirectoryPath $resolvedPath `
                       -MaxDepth $Depth `
                       -ExcludeDirectories $excludeList

foreach ($line in $treeLines) {
    $output.Add($line)
}

$output.Add('```')

# Output
$result = $output -join "`n"

if ($OutputFile) {
    $outputDir = Split-Path -Parent $OutputFile
    if ($outputDir -and -not (Test-Path -LiteralPath $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    $result | Out-File -FilePath $OutputFile -Encoding utf8
    Write-Host "Source tree saved to: $OutputFile" -ForegroundColor Green
} else {
    Write-Output $result
}
