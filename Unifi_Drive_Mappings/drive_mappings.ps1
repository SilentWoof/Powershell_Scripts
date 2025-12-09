# Desired mappings
$driveMappings = @{
    "M:" = "\\10.10.10.250\Personal-Drive"
    "O:" = "\\10.10.10.250\Editing"
    "Q:" = "\\10.10.10.250\Household"
    "S:" = "\\10.10.10.250\Family"
    "U:" = "\\10.10.10.250\INYB"
    "Y:" = "\\10.10.10.250\Public"
}

$incorrect = @()
$missing   = @()

Write-Host "Checking current drive mappings..." -ForegroundColor Cyan

# Phase 1: Check all drives
foreach ($drive in $driveMappings.Keys) {
    $path = $driveMappings[$drive]
    $current = Get-WmiObject Win32_NetworkConnection | Where-Object { $_.LocalName -eq $drive }

    if ($current) {
        if ($current.RemoteName -ne $path) {
            Write-Host "$drive is mapped incorrectly to $($current.RemoteName). Marking for remap." -ForegroundColor Yellow
            $incorrect += $drive
        } else {
            Write-Host "$drive is correctly mapped to $path." -ForegroundColor Green
        }
    } else {
        Write-Host "$drive is not mapped. Marking for mount." -ForegroundColor Yellow
        $missing += $drive
    }
}

# Phase 2: Unmount incorrect drives
foreach ($drive in $incorrect) {
    Write-Host "Unmounting incorrect mapping on $drive..." -ForegroundColor Red
    net use $drive /delete /y | Out-Null
}

# Phase 3: Mount missing drives (and those just freed)
foreach ($drive in $missing + $incorrect) {
    $path = $driveMappings[$drive]
    Write-Host "Mapping $drive to $path..." -ForegroundColor Cyan
    net use $drive $path | Out-Null
}

Write-Host "`nAll drive checks complete." -ForegroundColor Green

# Auto-close after 5 seconds if no errors
Write-Host "This window will close automatically in 5 seconds..." -ForegroundColor Magenta
Start-Sleep -Seconds 5
exit