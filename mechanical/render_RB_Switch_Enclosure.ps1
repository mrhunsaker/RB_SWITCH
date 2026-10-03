[CmdletBinding()]
param(
    [ValidateSet(
        "all",
        "printbar",
        "base",
        "lid_oneswitch",
        "lid",
        "lid_twoswitch",
        "lid_fingertrap"
    )]
    [string]$Part = "all",

    [string]$ScadPath = (Join-Path $PSScriptRoot "RB_Switch_Enclosure_corrected.scad"),

    [string]$OutputDir = (Join-Path $PSScriptRoot "stl"),

    [string]$OpenSCADPath = ""
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Find OpenSCAD
# ------------------------------------------------------------
function Find-OpenSCAD {
    if ($OpenSCADPath -and (Test-Path -LiteralPath $OpenSCADPath)) {
        return (Resolve-Path -LiteralPath $OpenSCADPath).Path
    }

    $cmd = Get-Command "openscad.exe" -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }

    $candidates = @(
        "$env:ProgramFiles\OpenSCAD\openscad.exe",
        "$env:ProgramFiles\OpenSCAD (Nightly)\openscad.exe",
        "$env:LOCALAPPDATA\Programs\OpenSCAD\openscad.exe",
        "$env:LOCALAPPDATA\OpenSCAD\openscad.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    throw @"
OpenSCAD was not found.

Install OpenSCAD or run this script with:
  -OpenSCADPath "C:\Path\To\openscad.exe"
"@
}

# ------------------------------------------------------------
# Validate input
# ------------------------------------------------------------
if (-not (Test-Path -LiteralPath $ScadPath)) {
    throw "SCAD file not found: $ScadPath"
}

$ScadPath = (Resolve-Path -LiteralPath $ScadPath).Path
$OpenSCAD = Find-OpenSCAD

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$OutputDir = (Resolve-Path -LiteralPath $OutputDir).Path

# These are the modules that should be exported.
$Parts = @(
    "printbar",
    "base",
    "lid_oneswitch",
    "lid",
    "lid_twoswitch",
    "lid_fingertrap"
)

if ($Part -ne "all") {
    $Parts = @($Part)
}

# ------------------------------------------------------------
# Create a temporary export wrapper.
#
# The SCAD currently contains:
#     all_assemblies();
#
# If we simply call OpenSCAD with -D, that assembly would also
# be rendered. The wrapper comments out that one top-level call
# and then calls only the requested module.
# ------------------------------------------------------------
$source = Get-Content -LiteralPath $ScadPath -Raw

$assemblyCall = "all_assemblies();"

if (-not $source.Contains($assemblyCall)) {
    throw "Could not find the expected 'all_assemblies();' line in $ScadPath"
}

$wrapper = $source.Replace(
    $assemblyCall,
    "// Disabled by export script: all_assemblies();"
)

$wrapper += @"



// ------------------------------------------------------------
// AUTOMATED STL EXPORT
// ------------------------------------------------------------
if (export_part == "printbar") {
    printbar();
}
else if (export_part == "base") {
    base();
}
else if (export_part == "lid_oneswitch") {
    lid_oneswitch();
}
else if (export_part == "lid") {
    lid();
}
else if (export_part == "lid_twoswitch") {
    lid_twoswitch();
}
else if (export_part == "lid_fingertrap") {
    lid_fingertrap();
}
"@

$tempWrapper = Join-Path $env:TEMP ("RB_Switch_Enclosure_export_{0}.scad" -f ([guid]::NewGuid().ToString("N")))

try {
    Set-Content -LiteralPath $tempWrapper -Value $wrapper -Encoding UTF8

    Write-Host ""
    Write-Host "OpenSCAD: $OpenSCAD"
    Write-Host "SCAD:     $ScadPath"
    Write-Host "Output:   $OutputDir"
    Write-Host ""

    foreach ($currentPart in $Parts) {
        $outputFile = Join-Path $OutputDir ("RB_Switch_Enclosure_{0}.stl" -f $currentPart)

        Write-Host ("Rendering {0} ..." -f $currentPart)

        # OpenSCAD receives one -D argument containing an OpenSCAD
        # string assignment, e.g. export_part="base".
        $args = @(
            "-o", $outputFile,
            "-D", ('export_part="{0}"' -f $currentPart),
            $tempWrapper
        )

        & $OpenSCAD @args

        if ($LASTEXITCODE -ne 0) {
            throw "OpenSCAD failed while rendering '$currentPart' (exit code $LASTEXITCODE)."
        }

        if (-not (Test-Path -LiteralPath $outputFile)) {
            throw "OpenSCAD reported success, but the STL was not created: $outputFile"
        }

        $sizeMB = [math]::Round(
            (Get-Item -LiteralPath $outputFile).Length / 1MB,
            2
        )

        Write-Host ("  Saved: {0} ({1} MB)" -f $outputFile, $sizeMB)
        Write-Host ""
    }

    Write-Host "Finished. STL files are in:"
    Write-Host "  $OutputDir"
}
finally {
    if (Test-Path -LiteralPath $tempWrapper) {
        Remove-Item -LiteralPath $tempWrapper -Force -ErrorAction SilentlyContinue
    }
}
