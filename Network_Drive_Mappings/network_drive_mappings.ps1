# Desired mappings
$driveMappings = @{
    "M:" = "\\10.10.10.250\Personal-Drive"
    "O:" = "\\10.10.10.250\Editing"
    "Q:" = "\\10.10.10.250\Household"
    "S:" = "\\10.10.10.250\Family"
    "U:" = "\\10.10.10.250\INYB"
    "Y:" = "\\10.10.10.250\Public"
}

function Get-CurrentMappings {
    $map = @{}
    $connections = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 4 }
    foreach ($conn in $connections) {
        $map[$conn.DeviceID] = $conn.ProviderName
    }
    return $map
}

function Unmount-Drive {
    param([string]$drive)
    Write-Host "Unmounting $drive..." -ForegroundColor Red
    try {
        net use $drive /delete /y | Out-Null
    } catch {
        Write-Host "Failed to unmount $drive. Error: $_" -ForegroundColor Red
    }
}

function Mount-Drive {
    param([string]$drive, [string]$path)
    Write-Host "Mapping $drive to $path..." -ForegroundColor Cyan
    try {
        net use $drive $path | Out-Null
    } catch {
        Write-Host "Failed to map $drive to $path. Error: $_" -ForegroundColor Red
    }
}

Write-Host "Assessing current drive mappings..." -ForegroundColor Cyan

$currentMappings = Get-CurrentMappings

# Phase 1: Identify drives to remove
$toRemove = @()

foreach ($drive in $currentMappings.Keys) {
    $path = $currentMappings[$drive]
    if (-not $driveMappings.ContainsKey($drive)) {
        # Drive letter not in desired set
        $toRemove += $drive
    } elseif ($driveMappings[$drive] -ne $path) {
        # Drive letter is in desired set but mapped to wrong path
        $toRemove += $drive
    }
}

# Phase 2: Unmount incorrect/extra drives
foreach ($drive in $toRemove) {
    Unmount-Drive -drive $drive
}

# Phase 3: Mount all desired drives
foreach ($desiredDrive in $driveMappings.Keys) {
    $desiredPath = $driveMappings[$desiredDrive]
    if ($currentMappings.ContainsKey($desiredDrive) -and $currentMappings[$desiredDrive] -eq $desiredPath) {
        Write-Host "$desiredDrive is already correctly mapped to $desiredPath." -ForegroundColor Green
    } else {
        Mount-Drive -drive $desiredDrive -path $desiredPath
    }
}

Write-Host "`nDrive reconciliation complete." -ForegroundColor Green
Write-Host "Press any key to close this window..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit