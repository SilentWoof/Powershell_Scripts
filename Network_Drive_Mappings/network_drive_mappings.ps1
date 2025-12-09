# Desired mappings
$driveMappings = @{
    "M:" = "\\10.10.10.250\Personal-Drive"
    "O:" = "\\10.10.10.250\Editing"
    "Q:" = "\\10.10.10.250\Household"
    "S:" = "\\10.10.10.250\Family"
    "U:" = "\\10.10.10.250\INYB"
    "Y:" = "\\10.10.10.250\Public"
}

function Get-DriveStatus {
    param([string]$drive, [string]$path)

    $current = Get-CimInstance Win32_NetworkConnection | Where-Object { $_.LocalName -eq $drive }

    if ($current) {
        if ($current.RemoteName -ne $path) {
            Write-Host "$drive is mapped incorrectly to $($current.RemoteName). Marking for remap." -ForegroundColor Yellow
            return "Incorrect"
        } else {
            Write-Host "$drive is correctly mapped to $path." -ForegroundColor Green
            return "Correct"
        }
    } else {
        Write-Host "$drive is not mapped. Marking for mount." -ForegroundColor Yellow
        return "Missing"
    }
}

function Unmount-Drive {
    param([string]$drive)
    Write-Host "Unmounting incorrect mapping on $drive..." -ForegroundColor Red
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

Write-Host "Checking current drive mappings..." -ForegroundColor Cyan

$incorrect = @()
$missing   = @()

# Phase 1: Check all drives
foreach ($drive in $driveMappings.Keys) {
    $status = Get-DriveStatus -drive $drive -path $driveMappings[$drive]
    switch ($status) {
        "Incorrect" { $incorrect += $drive }
        "Missing"   { $missing   += $drive }
    }
}

# Phase 2: Unmount incorrect drives
foreach ($drive in $incorrect) {
    Unmount-Drive -drive $drive
}

# Phase 3: Mount missing + incorrect drives
foreach ($drive in $missing + $incorrect) {
    Mount-Drive -drive $drive -path $driveMappings[$drive]
}

Write-Host "`nAll drive checks complete." -ForegroundColor Green

# Auto-close after 5 seconds
Write-Host "This window will close automatically in 5 seconds..." -ForegroundColor Magenta
Start-Sleep -Seconds 5
exit